# ── main.tf ────────────────────────────────────
# Copyright (c) 2021-2023 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

# File Version: 0.9.2

resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = local.oke_compartment_ocid
  kubernetes_version = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
  name               = "${local.app_name} (${local.deploy_id})"
  vcn_id             = var.vcn_id
  kms_key_id         = var.oci_vault_key_id_oke_secrets != "" ? var.oci_vault_key_id_oke_secrets : null
  type               = var.cluster_type
  freeform_tags      = var.cluster_tags.freeformTags
  defined_tags       = var.cluster_tags.definedTags

  endpoint_config {
    is_public_ip_enabled = (var.cluster_endpoint_visibility == "Private") ? false : true
    subnet_id            = var.k8s_endpoint_subnet_id
    nsg_ids              = []
  }
  options {
    service_lb_subnet_ids = [var.lb_subnet_id]
    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = false # Default is false, left here for reference
    }
    admission_controller_options {
      is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
    }
    kubernetes_network_config {
      services_cidr = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
      pods_cidr     = lookup(var.network_cidrs, "PODS-CIDR")
    }
    persistent_volume_config {
      freeform_tags = var.block_volumes_tags.freeformTags
      # defined_tags  = var.block_volumes_tags.definedTags
    }
    service_lb_config {
      freeform_tags = var.load_balancers_tags.freeformTags
      # defined_tags  = var.load_balancers_tags.definedTags
    }
    open_id_connect_discovery {
      is_open_id_connect_discovery_enabled = var.oke_cluster_oidc_discovery
   }
  }
  image_policy_config {
    is_policy_enabled = false
    # key_details {
    #   # kms_key_id = var.oci_vault_key_id_oke_image_policy != "" ? var.oci_vault_key_id_oke_image_policy : null
    # }
  }
  cluster_pod_network_options {
    cni_type = var.cni_type
  }

  lifecycle {
    ignore_changes = [freeform_tags, defined_tags, kubernetes_version, id]
  }
  count = var.create_new_oke_cluster ? 1 : 0
}

# Local kubeconfig for when using Terraform locally. Not used by Oracle Resource Manager
resource "local_file" "oke_kubeconfig" {
  content         = data.oci_containerengine_cluster_kube_config.oke.content
  filename        = "${path.root}/generated/kubeconfig"
  file_permission = "0644"
}

# Get OKE options
locals {
  cluster_k8s_latest_version = reverse(sort(data.oci_containerengine_cluster_option.oke.kubernetes_versions))[0]
  deployed_k8s_version = var.create_new_oke_cluster ? ((var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version) : [
  for x in data.oci_containerengine_clusters.oke.clusters : x.kubernetes_version if x.id == var.existent_oke_cluster_id][0]
}


# ── variables.tf ────────────────────────────────────
# Copyright (c) 2021, 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# OCI Provider
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}

# Network Details
variable "vcn_id" { description = "VCN OCID to deploy OKE Cluster" }
variable "k8s_endpoint_subnet_id" { description = "Kubernetes Endpoint Subnet OCID to deploy OKE Cluster" }
variable "lb_subnet_id" { description = "Load Balancer Subnet OCID to deploy OKE Cluster" }
variable "cluster_workers_visibility" {
  default     = "Private"
  description = "The Kubernetes worker nodes that are created will be hosted in public or private subnet(s)"
}
variable "cluster_endpoint_visibility" {
  default     = "Public"
  description = "The Kubernetes cluster that is created will be hosted on a public subnet with a public IP address auto-assigned or on a private subnet. If Private, additional configuration will be necessary to run kubectl commands"
}
variable "network_cidrs" {}
variable "cni_type" {
  default     = "FLANNEL_OVERLAY"
  description = "The CNI type to use for the cluster. Valid values are: FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE"

  validation {
    condition     = var.cni_type == "FLANNEL_OVERLAY" || var.cni_type == "OCI_VCN_IP_NATIVE"
    error_message = "Sorry, but OKE currently only supports FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE CNI types."
  }
}

# OKE Variables
## OKE Cluster Details
variable "create_new_oke_cluster" {
  default     = false
  description = "Creates a new OKE cluster and node pool"
}
variable "existent_oke_cluster_id" {
  default     = ""
  description = "Using existent OKE Cluster. Only the application and services will be provisioned. If select cluster autoscaler feature, you need to get the node pool id and enter when required"
}
variable "cluster_type" {
  default     = "BASIC_CLUSTER"
  description = "The type of OKE cluster to create. Valid values are: BASIC_CLUSTER or ENHANCED_CLUSTER"
}
variable "create_orm_private_endpoint" {
  default     = false
  description = "Creates a new private endpoint for the OKE cluster"
}
variable "existent_oke_cluster_private_endpoint" {
  default     = ""
  description = "Resource Manager Private Endpoint to access the OKE Private Cluster"
}
variable "create_new_compartment_for_oke" {
  default     = false
  description = "Creates new compartment for OKE Nodes and OCI Services deployed.  NOTE: The creation of the compartment increases the deployment time by at least 3 minutes, and can increase by 15 minutes when destroying"
}
variable "oke_compartment_description" {
  default = "Compartment for OKE, Nodes and Services"
}
variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = false
}
variable "cluster_options_admission_controller_options_is_pod_security_policy_enabled" {
  description = "If true: The pod security policy admission controller will use pod security policies to restrict the pods accepted into the cluster."
  default     = false
}

## OKE Encryption details
variable "oci_vault_key_id_oke_secrets" {
  default     = null
  description = "OCI Vault OCID to encrypt OKE secrets. If not provided, the secrets will be encrypted with the default key"
}
variable "oci_vault_key_id_oke_image_policy" {
  default     = null
  description = "OCI Vault OCID for the Image Policy"
}

variable "create_vault_policies_for_group" {
  default     = false
  description = "Creates policies to allow the user applying the stack to manage vault and keys. If you are on the Administrators group or already have the policies for a compartment, this policy is not needed. If you do not have access to allow the policy, ask your administrator to include it for you"
}
variable "user_admin_group_for_vault_policy" {
  default     = "Administrators"
  description = "User Identity Group to allow manage vault and keys. The user running the Terraform scripts or Applying the ORM Stack need to be on this group"
}

variable "k8s_version" {
  default     = "Latest"
  description = "Kubernetes version installed on your Control Plane"
}

# Create Dynamic Group and Policies
# variable "create_dynamic_group_for_nodes_in_compartment" {
#   default     = false # TODO: true 
#   description = "Creates dynamic group of Nodes in the compartment. Note: You need to have proper rights on the Tenancy. If you only have rights in a compartment, uncheck and ask you administrator to create the Dynamic Group for you"
# }
# variable "existent_dynamic_group_for_nodes_in_compartment" {
#   default     = ""
#   description = "Enter previous created Dynamic Group for the policies"
# }
# variable "create_compartment_policies" {
#   default     = false # TODO: true 
#   description = "Creates policies that will reside on the compartment. e.g.: Policies to support Cluster Autoscaler, OCI Logging datasource on Grafana"
# }
# variable "create_tenancy_policies" {
#   default     = false # TODO: true 
#   description = "Creates policies that need to reside on the tenancy. e.g.: Policies to support OCI Metrics datasource on Grafana"
# }

# ORM Schema visual control variables
variable "show_advanced" {
  default = false
}

# App Name Locals
locals {
  app_name            = var.cluster_tags.freeformTags.AppName
  deploy_id           = var.cluster_tags.freeformTags.DeploymentID
  app_name_normalized = substr(replace(lower(var.cluster_tags.freeformTags.AppName), " ", "-"), 0, 6)
  app_name_for_dns    = substr(lower(replace(var.cluster_tags.freeformTags.AppName, "/\\W|_|\\s/", "")), 0, 6)
}

# OKE Compartment
locals {
  oke_compartment_ocid = var.compartment_ocid
}
# OIDC
variable "oke_cluster_oidc_discovery" {
  default       = false
  description = "Enable OpenID Connect discovery in the cluster"
}

# Deployment Details + Freeform Tags
variable "cluster_tags" {
  description = "Tags to be added to the cluster resources"
}
variable "load_balancers_tags" {
  description = "Tags to be added to the load balancers resources"
}
variable "block_volumes_tags" {
  description = "Tags to be added to the block volumes resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "comments" {
  value = "The application URL will be unavailable for a few minutes after provisioning while the application is configured and deployed to Kubernetes"
}
output "deployed_oke_kubernetes_version" {
  value = local.deployed_k8s_version
}
output "deployed_to_region" {
  value = var.region
}
output "dev" {
  value = "Made with \u2764 by Oracle Developers. Forked and Hacked by @Clouddude🍉"
}
output "kubeconfig" {
  value = data.oci_containerengine_cluster_kube_config.oke.content
}
output "kubeconfig_for_kubectl" {
  value       = "export KUBECONFIG=${path.root}/generated/kubeconfig"
  description = "If using Terraform locally, this command set KUBECONFIG environment variable to run kubectl locally"
}
output "orm_private_endpoint_oke_api_ip_address" {
  value       = (var.cluster_endpoint_visibility == "Private") ? data.oci_resourcemanager_private_endpoint_reachable_ip.private_kubernetes_endpoint.0.ip_address : ""
  description = "OCI Resource Manager Private Endpoint ip address for OKE Kubernetes API Private Endpoint"

  depends_on = [
    oci_resourcemanager_private_endpoint.private_kubernetes_endpoint
  ]
}

# OKE info
output "oke_cluster_ocid" {
  value       = var.create_new_oke_cluster ? oci_containerengine_cluster.oke_cluster[0].id : ""
  description = "OKE Cluster OCID"
}
output "oke_cluster_compartment_ocid" {
  value       = local.oke_compartment_ocid
  description = "Compartment OCID used by the OKE Cluster"
}


# ── versions.tf ────────────────────────────────────
# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

terraform {
  required_version = ">= 1.1"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5" #"~> 4, < 5"
      # https://registry.terraform.io/providers/oracle/oci/
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2" #"~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
  }
}


# ── datasources.tf ────────────────────────────────────
# Copyright (c) 2021-2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

data "oci_containerengine_cluster_option" "oke" {
  cluster_option_id = "all"
}
data "oci_containerengine_clusters" "oke" {
  compartment_id = local.oke_compartment_ocid
}

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# Gets kubeconfig
data "oci_containerengine_cluster_kube_config" "oke" {
  cluster_id = var.create_new_oke_cluster ? oci_containerengine_cluster.oke_cluster[0].id : var.existent_oke_cluster_id
}


# ── oke-orm-private-endpoint.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

### Important Notice ###
# OCI Resource Manager Private Endpoint is only available when using Resource Manager.
# If you use local Terraform, you will need to setup an OCI Bastion for connectivity to the Private OKE.
# If using OCI CloudShell, you need to activate the OCI Private Endpoint for OCI CLoud Shell.

resource "oci_resourcemanager_private_endpoint" "private_kubernetes_endpoint" {
  compartment_id = local.oke_compartment_ocid
  display_name   = "Private Endpoint for OKE ${local.app_name} - ${local.deploy_id}"
  description    = "Resource Manager Private Endpoint for OKE for the ${local.app_name} - ${local.deploy_id}"
  vcn_id         = var.vcn_id
  subnet_id      = var.k8s_endpoint_subnet_id
  freeform_tags  = var.cluster_tags.freeformTags
  defined_tags   = var.cluster_tags.definedTags

  count = var.create_new_oke_cluster ? ((var.cluster_endpoint_visibility == "Private") ? 1 : 0) : 0
}

# Resolves the private IP of the customer's private endpoint to a NAT IP.
data "oci_resourcemanager_private_endpoint_reachable_ip" "private_kubernetes_endpoint" {
  private_endpoint_id = var.create_new_oke_cluster ? oci_resourcemanager_private_endpoint.private_kubernetes_endpoint[0].id : var.existent_oke_cluster_private_endpoint
  private_ip          = trimsuffix(oci_containerengine_cluster.oke_cluster[0].endpoints.0.private_endpoint, ":6443") # TODO: Pending rule when has existent cluster

  count = (var.cluster_endpoint_visibility == "Private") ? 1 : 0
}