# ── main.tf ────────────────────────────────────
# Copyright (c) 2021, 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

##**************************************************************************
##                            OCI KMS Vault
##**************************************************************************

### OCI Vault vault
resource "oci_kms_vault" "oke_vault" {
  compartment_id = var.oke_cluster_compartment_ocid
  display_name   = "${local.vault_display_name} - ${local.deploy_id}"
  vault_type     = local.vault_type[0]
  freeform_tags  = var.oci_tag_values.freeformTags
  defined_tags   = var.oci_tag_values.definedTags

  # depends_on = [oci_identity_policy.kms_user_group_compartment_policies]

  count = var.use_encryption_from_oci_vault ? (var.create_new_encryption_key ? 1 : 0) : 0
}
### OCI Vault key
resource "oci_kms_key" "oke_key" {
  compartment_id      = var.oke_cluster_compartment_ocid
  display_name        = "${local.vault_key_display_name} - ${local.deploy_id}"
  management_endpoint = oci_kms_vault.oke_vault[0].management_endpoint
  protection_mode     = local.vault_key_protection_mode
  freeform_tags       = var.oci_tag_values.freeformTags
  defined_tags        = var.oci_tag_values.definedTags

  key_shape {
    algorithm = local.vault_key_key_shape_algorithm
    length    = local.vault_key_key_shape_length
  }

  count = var.use_encryption_from_oci_vault ? (var.create_new_encryption_key ? 1 : 0) : 0
}

### Vault and Key definitions
locals {
  vault_display_name            = "OKE Vault"
  vault_key_display_name        = "OKE Key"
  vault_key_key_shape_algorithm = "AES"
  vault_key_key_shape_length    = 32
  vault_type                    = ["DEFAULT", "VIRTUAL_PRIVATE"]
  vault_key_protection_mode     = "SOFTWARE" # HSM or SOFTWARE
  oci_vault_key_id              = var.use_encryption_from_oci_vault ? (var.create_new_encryption_key ? oci_kms_key.oke_key[0].id : var.existent_encryption_key_id) : "void"
}

# ── variables.tf ────────────────────────────────────
# Copyright (c) 2021, 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# OKE Encryption details
variable "use_encryption_from_oci_vault" {
  default     = false
  description = "By default, Oracle manages the keys that encrypts Kubernetes Secrets at Rest in Etcd, but you can choose a key from a vault that you have access to, if you want greater control over the key's lifecycle and how it's used"
}
variable "create_new_encryption_key" {
  default     = false
  description = "Creates new vault and key on OCI Vault/Key Management/KMS and assign to boot volume of the worker nodes"
}
variable "existent_encryption_key_id" {
  default     = ""
  description = "Use an existent master encryption key to encrypt boot volume and object storage bucket. NOTE: If the key resides in a different compartment or in a different tenancy, make sure you have the proper policies to access, or the provision of the worker nodes will fail"
}

# Deployment Details + Freeform Tags
variable "oci_tag_values" {
  description = "Tags to be added to the resources"
}

# OKE Variables
variable "oke_cluster_compartment_ocid" {
  description = "Compartment OCID used by the OKE Cluster"
  type        = string
}

# Policies variables
variable "create_vault_policies_for_group" {
  default     = false
  description = "Creates policies to allow the user applying the stack to manage vault and keys. If you are on the Administrators group or already have the policies for a compartment, this policy is not needed. If you do not have access to allow the policy, ask your administrator to include it for you"
}
variable "user_admin_group_for_vault_policy" {
  default     = "Administrators"
  description = "User Identity Group to allow manage vault and keys. The user running the Terraform scripts or Applying the ORM Stack need to be on this group"
}
## Create Dynamic Group and Policies
variable "create_dynamic_group_for_nodes_in_compartment" {
  default     = false
  description = "Creates dynamic group of Nodes in the compartment. Note: You need to have proper rights on the Tenancy. If you only have rights in a compartment, uncheck and ask you administrator to create the Dynamic Group for you"
}
variable "create_compartment_policies" {
  default     = false
  description = "Creates policies for KMS that will reside on the compartment."
}

# OCI Provider
variable "tenancy_ocid" {}

# Conditional locals
locals {
  app_dynamic_group   = (var.use_encryption_from_oci_vault && var.create_dynamic_group_for_nodes_in_compartment) ? oci_identity_dynamic_group.app_dynamic_group.0.name : "void"
  app_name_normalized = substr(replace(lower(var.oci_tag_values.freeformTags.AppName), " ", "-"), 0, 6)
  app_name            = var.oci_tag_values.freeformTags.AppName
  deploy_id           = var.oci_tag_values.freeformTags.DeploymentID
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "oci_vault_key_id" {
  value = var.use_encryption_from_oci_vault ? (var.create_new_encryption_key ? oci_kms_key.oke_key[0].id : var.existent_encryption_key_id) : null
}

# ── providers.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 1.5" # ">= 1.1"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6" #"~> 4"
      # https://registry.terraform.io/providers/oracle/oci/
      configuration_aliases = [oci.home_region]
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
  }
}

# ── policies.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_identity_dynamic_group" "app_dynamic_group" {
  name           = "${local.app_name_normalized}-kms-dg-${local.deploy_id}"
  description    = "${local.app_name} KMS for OKE Dynamic Group (${local.deploy_id})"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ANY {${join(",", local.dynamic_group_matching_rules)}}"

  provider = oci.home_region

  count = (var.use_encryption_from_oci_vault && var.create_dynamic_group_for_nodes_in_compartment) ? 1 : 0
}
resource "oci_identity_policy" "app_compartment_policies" {
  name           = "${local.app_name_normalized}-kms-compartment-policies-${local.deploy_id}"
  description    = "${local.app_name} KMS for OKE Compartment Policies (${local.deploy_id})"
  compartment_id = var.oke_cluster_compartment_ocid
  statements     = local.app_compartment_statements

  depends_on = [oci_identity_dynamic_group.app_dynamic_group]

  provider = oci.home_region

  count = (var.use_encryption_from_oci_vault && var.create_compartment_policies) ? 1 : 0
}
resource "oci_identity_policy" "kms_user_group_compartment_policies" {
  name           = "${local.app_name_normalized}-kms-compartment-policies-${local.deploy_id}"
  description    = "${local.app_name} KMS User Group Compartment Policies (${local.deploy_id})"
  compartment_id = var.oke_cluster_compartment_ocid
  statements     = local.kms_user_group_compartment_statements

  depends_on = [oci_identity_dynamic_group.app_dynamic_group]

  provider = oci.home_region

  count = (var.use_encryption_from_oci_vault && var.create_compartment_policies && var.create_vault_policies_for_group) ? 1 : 0
}

# Concat Matching Rules and Policy Statements
locals {
  dynamic_group_matching_rules = concat(
    local.instances_in_compartment_rule,
    local.clusters_in_compartment_rule
  )
  app_compartment_statements = concat(
    local.allow_oke_use_oci_vault_keys_statements
  )
  kms_user_group_compartment_statements = concat(
    local.allow_group_manage_vault_keys_statements
  )
}

# Individual Rules
locals {
  instances_in_compartment_rule = ["ALL {instance.compartment.id = '${var.oke_cluster_compartment_ocid}'}"]
  clusters_in_compartment_rule  = ["ALL {resource.type = 'cluster', resource.compartment.id = '${var.oke_cluster_compartment_ocid}'}"]
}

# Individual Policy Statements
locals {
  allow_oke_use_oci_vault_keys_statements = [
    "Allow service oke to use vaults in compartment id ${var.oke_cluster_compartment_ocid}",
    "Allow service oke to use keys in compartment id ${var.oke_cluster_compartment_ocid} where target.key.id = '${local.oci_vault_key_id}'",
    "Allow service oke to use key-delegates in compartment id ${var.oke_cluster_compartment_ocid} where target.key.id = '${local.oci_vault_key_id}'",
    "Allow service blockstorage to use keys in compartment id ${var.oke_cluster_compartment_ocid} where target.key.id = '${local.oci_vault_key_id}'",
    "Allow dynamic-group ${local.app_dynamic_group} to use keys in compartment id ${var.oke_cluster_compartment_ocid} where target.key.id = '${local.oci_vault_key_id}'",
    "Allow dynamic-group ${local.app_dynamic_group} to use key-delegates in compartment id ${var.oke_cluster_compartment_ocid} where target.key.id = '${local.oci_vault_key_id}'"
  ]
  allow_group_manage_vault_keys_statements = [
    "Allow group ${var.user_admin_group_for_vault_policy} to manage vaults in compartment id ${var.oke_cluster_compartment_ocid}",
    "Allow group ${var.user_admin_group_for_vault_policy} to manage keys in compartment id ${var.oke_cluster_compartment_ocid}",
    "Allow group ${var.user_admin_group_for_vault_policy} to use key-delegate in compartment id ${var.oke_cluster_compartment_ocid}"
  ]
}
