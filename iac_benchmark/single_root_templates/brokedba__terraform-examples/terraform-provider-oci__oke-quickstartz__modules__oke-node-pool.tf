# ── main.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# File Version: 0.7.1

resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = var.oke_cluster_ocid
  compartment_id     = var.oke_cluster_compartment_ocid
  kubernetes_version = local.node_k8s_version
  name               = var.node_pool_name
  node_shape         = var.node_pool_shape
  ssh_public_key     = var.public_ssh_key
  freeform_tags      = var.node_pools_tags.freeformTags
  defined_tags       = var.node_pools_tags.definedTags

  node_config_details {
    dynamic "placement_configs" {
      for_each = local.node_pool_ads # data.oci_identity_availability_domains.ADs.availability_domains

      content {
        availability_domain = placement_configs.value.name
        subnet_id           = var.nodes_subnet_id
      }
    }
    node_pool_pod_network_option_details {
      cni_type          = var.cni_type
      max_pods_per_node = 0 # 31
      pod_nsg_ids       = []
      pod_subnet_ids    = var.vcn_native_pod_networking_subnet_ocid != null ? [var.vcn_native_pod_networking_subnet_ocid] : [] #[var.vcn_native_pod_networking_subnet_ocid]
    }
    # nsg_ids       = []
    size = var.node_pool_min_nodes
    # is_pv_encryption_in_transit_enabled = var.node_pool_node_config_details_is_pv_encryption_in_transit_enabled
    kms_key_id    = var.oci_vault_key_id_oke_node_boot_volume != "" ? var.oci_vault_key_id_oke_node_boot_volume : null
    freeform_tags = var.worker_nodes_tags.freeformTags
    defined_tags  = var.worker_nodes_tags.definedTags
  }

  dynamic "node_shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      ocpus         = var.node_pool_node_shape_config_ocpus
      memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
    }
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = lookup(data.oci_core_images.node_pool_images.images[0], "id")
    boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
  }

  # node_eviction_node_pool_settings {
  #   eviction_grace_duration = var.node_pool_node_eviction_node_pool_settings_eviction_grace_duration #PT60M
  #   is_force_delete_after_grace_duration = var.node_pool_node_eviction_node_pool_settings_is_force_delete_after_grace_duration #false
  # }

  node_metadata = {
    user_data = anytrue([var.node_pool_oke_init_params != "", var.node_pool_cloud_init_parts != []]) ? data.cloudinit_config.nodes.rendered : null
  }

  # node_pool_cycling_details {
  #       is_node_cycling_enabled = var.node_pool_node_pool_cycling_details_is_node_cycling_enabled
  #       maximum_surge = var.node_pool_node_pool_cycling_details_maximum_surge
  #       maximum_unavailable = var.node_pool_node_pool_cycling_details_maximum_unavailable
  # }

  initial_node_labels {
    key   = "name"
    value = var.node_pool_name
  }

  dynamic "initial_node_labels" {
    for_each = var.extra_initial_node_labels

    content {
      key   = initial_node_labels.value.key
      value = initial_node_labels.value.value
    }
  }

  lifecycle {
    ignore_changes = [
      node_config_details.0.size,
      node_source_details.0.image_id  # Add this line to ignore changes to image_id
    ]
  }

  count = var.create_new_node_pool ? 1 : 0
}

locals {
  # Checks if is using Flexible Compute Shapes
  is_flexible_node_shape = contains(split(".", var.node_pool_shape), "Flex")

  # Gets the latest Kubernetes version supported by the node pool
  node_pool_k8s_latest_version = reverse(sort(data.oci_containerengine_node_pool_option.node_pool.kubernetes_versions))[0]
  node_k8s_version             = (var.node_k8s_version == "Latest") ? local.node_pool_k8s_latest_version : var.node_k8s_version

  # Get ADs for the shape to be used on the node pool
  node_pool_ads = (var.node_pool_shape_specific_ad > 0) ? data.oci_identity_availability_domain.specfic : data.oci_identity_availability_domains.ADs.availability_domains
}


# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

# OKE Variables
variable "oke_cluster_ocid" {
  description = "OKE cluster OCID"
  type        = string
}
variable "oke_cluster_compartment_ocid" {
  description = "Compartment OCID used by the OKE Cluster"
  type        = string
}

## Node Pool Variables
variable "create_new_node_pool" {
  default     = true
  description = "Create a new node pool if true or use an existing one if false"
}
variable "node_k8s_version" {
  description = "Kubernetes version installed on your worker nodes"
  type        = string
  default     = "v1.29.1" #"Latest"
}
variable "node_pool_name" {
  default     = "pool1"
  description = "Name of the node pool"
}
variable "extra_initial_node_labels" {
  default     = {}
  description = "Extra initial node labels to be added to the node pool"
}
variable "node_pool_min_nodes" {
  default     = 2 #3
  description = "The number of worker nodes in the node pool. If select Cluster Autoscaler, will assume the minimum number of nodes configured"
}
variable "node_pool_max_nodes" {
  default     = 2
  description = "The max number of worker nodes in the node pool if using Cluster Autoscaler."
}
variable "node_pool_shape" {
  default     = "VM.Standard.E4.Flex"
  description = "A shape is a template that determines the number of OCPUs, amount of memory, and other resources allocated to a newly created instance for the Worker Node"
}
variable "node_pool_node_shape_config_ocpus" {
  default     = "2" # Only used if flex shape is selected
  description = "You can customize the number of OCPUs to a flexible shape"
}
variable "node_pool_node_shape_config_memory_in_gbs" {
  default     = "16" # Only used if flex shape is selected
  description = "You can customize the amount of memory allocated to a flexible shape"
}
variable "node_pool_shape_specific_ad" {
  description = "The number of the AD to get the shape for the node pool"
  type        = number
  default     = 0

  validation {
    condition     = var.node_pool_shape_specific_ad >= 0 && var.node_pool_shape_specific_ad <= 3
    error_message = "Invalid AD number, should be 0 to get all ADs or 1, 2 or 3 to be a specific AD."
  }
}
variable "cni_type" {
  default     = "FLANNEL_OVERLAY"
  description = "The CNI type to use for the cluster. Valid values are: FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE"

  validation {
    condition     = var.cni_type == "FLANNEL_OVERLAY" || var.cni_type == "OCI_VCN_IP_NATIVE"
    error_message = "Sorry, but OKE currently only supports FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE CNI types."
  }
}
variable "existent_oke_nodepool_id_for_autoscaler" {
  default     = ""
  description = "Nodepool Id of the existent OKE to use with Cluster Autoscaler"
}
variable "node_pool_autoscaler_enabled" {
  default     = true
  description = "Enable Cluster Autoscaler for the node pool"
}
variable "image_operating_system" {
  default     = "Oracle Linux"
  description = "The OS/image installed on all nodes in the node pool."
}
variable "image_operating_system_version" {
  default     = "8"
  description = "The OS/image version installed on all nodes in the node pool."
}
variable "node_pool_boot_volume_size_in_gbs" {
  default     = "50"
  description = "Specify a custom boot volume size (in GB)"
}
variable "node_pool_oke_init_params" {
  type        = string
  default     = ""
  description = "OKE Init params"
}
variable "node_pool_cloud_init_parts" {
  type = list(object({
    content_type = string
    content      = string
    filename     = string
  }))
  default     = []
  description = "Node Pool nodes Cloud init parts"
}
variable "public_ssh_key" {
  default     = ""
  description = "In order to access your private nodes with a public SSH key you will need to set up a bastion host (a.k.a. jump box). If using public nodes, bastion is not needed. Left blank to not import keys."
}

# OKE Network Variables
variable "nodes_subnet_id" { description = "Nodes Subnet OCID to deploy OKE Cluster" }
variable "vcn_native_pod_networking_subnet_ocid" {
 # default     = ""
 description = "VCN Native Pod Networking Subnet OCID used by the OKE Cluster"
  default     = null

  validation {
    condition     = can(regex("^ocid1.subnet.oc1..*", var.vcn_native_pod_networking_subnet_ocid)) || var.vcn_native_pod_networking_subnet_ocid == null
    error_message = "The subnet OCID must be a valid OCI subnet OCID or null."
  }
}

# Customer Manager Encryption Keys
variable "oci_vault_key_id_oke_node_boot_volume" {
  description = "OCI Vault Key OCID used to encrypt the OKE node boot volume"
  type        = string
  default     = null
}

# OCI Provider
variable "tenancy_ocid" {}

# App Name Locals
locals {
  app_name_normalized = substr(replace(lower(var.node_pools_tags.freeformTags.AppName), " ", "-"), 0, 6)
}

# Deployment Details + Freeform Tags
variable "node_pools_tags" {
  description = "Tags to be added to the node pools resources"
}
variable "worker_nodes_tags" {
  description = "Tags to be added to the worker nodes resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "node_pool_name" {
  value = var.create_new_node_pool ? oci_containerengine_node_pool.oke_node_pool.0.name : var.existent_oke_nodepool_id_for_autoscaler
}
output "node_pool_min_nodes" {
  value = var.node_pool_min_nodes
}
output "node_pool_max_nodes" {
  value = var.node_pool_max_nodes
}
output "node_pool_id" {
  value = var.create_new_node_pool ? oci_containerengine_node_pool.oke_node_pool.0.id : var.existent_oke_nodepool_id_for_autoscaler
}
output "node_k8s_version" {
  value = local.node_k8s_version
}
output "node_pool_autoscaler_enabled" {
  value = var.node_pool_autoscaler_enabled
}

# ── versions.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 1.5" #">= 1.1"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6" #"~> 4, < 5"
      # https://registry.terraform.io/providers/oracle/oci/
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
  }
}

# ── datasources.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Gets supported Kubernetes versions for node pools
data "oci_containerengine_node_pool_option" "node_pool" {
  node_pool_option_id = "all"
}

# Gets a list of supported images based on the shape, operating_system and operating_system_version provided
data "oci_core_images" "node_pool_images" {
  compartment_id           = var.oke_cluster_compartment_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.node_pool_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}
# Gets a specfic Availability Domain
data "oci_identity_availability_domain" "specfic" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.node_pool_shape_specific_ad

  count = (var.node_pool_shape_specific_ad > 0) ? 1 : 0
}

# Prepare Cloud Unit for Node Pool nodes
data "cloudinit_config" "nodes" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash
curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode >/var/run/oke-init.sh
bash /var/run/oke-init.sh ${var.node_pool_oke_init_params}
/usr/libexec/oci-growfs -y
EOF
  }

  dynamic "part" {
    for_each = var.node_pool_cloud_init_parts
    content {
      content_type = part.value["content_type"]
      content      = part.value["content"]
      filename     = part.value["filename"]
    }
  }
}