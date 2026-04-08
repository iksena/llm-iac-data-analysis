variable "name" {
  description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
  type        = string

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9\\-_]*$", var.name))
    error_message = "resource_aws_eks_cluster, name must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores (^[0-9A-Za-z][A-Za-z0-9\\-_]*$)."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 100
    error_message = "resource_aws_eks_cluster, name must be between 1-100 characters in length."
  }
}

variable "role_arn" {
  description = "ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.role_arn))
    error_message = "resource_aws_eks_cluster, role_arn must be a valid IAM role ARN."
  }
}

variable "vpc_config" {
  description = "Configuration block for the VPC associated with your cluster."
  type = object({
    endpoint_private_access = optional(bool, false)
    endpoint_public_access  = optional(bool, true)
    public_access_cidrs     = optional(list(string))
    security_group_ids      = optional(list(string))
    subnet_ids              = list(string)
  })

  validation {
    condition     = length(var.vpc_config.subnet_ids) >= 2
    error_message = "resource_aws_eks_cluster, vpc_config subnet_ids must be in at least two different availability zones."
  }
}

variable "access_config" {
  description = "Configuration block for the access config associated with your cluster."
  type = object({
    authentication_mode                         = optional(string)
    bootstrap_cluster_creator_admin_permissions = optional(bool, true)
  })
  default = null

  validation {
    condition = var.access_config == null || (
      var.access_config.authentication_mode == null ||
      contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP"], var.access_config.authentication_mode)
    )
    error_message = "resource_aws_eks_cluster, access_config authentication_mode must be one of: CONFIG_MAP, API, API_AND_CONFIG_MAP."
  }
}

variable "bootstrap_self_managed_addons" {
  description = "Install default unmanaged add-ons, such as aws-cni, kube-proxy, and CoreDNS during cluster creation."
  type        = bool
  default     = true
}

variable "compute_config" {
  description = "Configuration block with compute configuration for EKS Auto Mode."
  type = object({
    enabled       = optional(bool)
    node_pools    = optional(list(string))
    node_role_arn = optional(string)
  })
  default = null

  validation {
    condition = var.compute_config == null || (
      var.compute_config.node_pools == null ||
      alltrue([for pool in var.compute_config.node_pools : contains(["general-purpose", "system"], pool)])
    )
    error_message = "resource_aws_eks_cluster, compute_config node_pools must contain only 'general-purpose' or 'system'."
  }

  validation {
    condition = var.compute_config == null || (
      var.compute_config.node_role_arn == null ||
      can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.compute_config.node_role_arn))
    )
    error_message = "resource_aws_eks_cluster, compute_config node_role_arn must be a valid IAM role ARN."
  }
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the cluster."
  type        = bool
  default     = false
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable."
  type        = list(string)
  default     = null

  validation {
    condition = var.enabled_cluster_log_types == null || (
      alltrue([for log_type in var.enabled_cluster_log_types : contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], log_type)])
    )
    error_message = "resource_aws_eks_cluster, enabled_cluster_log_types must contain only valid log types: api, audit, authenticator, controllerManager, scheduler."
  }
}

variable "encryption_config" {
  description = "Configuration block with encryption configuration for the cluster."
  type = list(object({
    provider = object({
      key_arn = string
    })
    resources = list(string)
  }))
  default = null

  validation {
    condition = var.encryption_config == null || (
      alltrue([
        for config in var.encryption_config :
        alltrue([for resource in config.resources : contains(["secrets"], resource)])
      ])
    )
    error_message = "resource_aws_eks_cluster, encryption_config resources must contain only 'secrets'."
  }

  validation {
    condition = var.encryption_config == null || (
      alltrue([
        for config in var.encryption_config :
        can(regex("^arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-zA-Z0-9-]+$", config.provider.key_arn))
      ])
    )
    error_message = "resource_aws_eks_cluster, encryption_config provider key_arn must be a valid KMS key ARN."
  }
}

variable "force_update_version" {
  description = "Force version update by overriding upgrade-blocking readiness checks when updating a cluster."
  type        = bool
  default     = null
}

variable "kubernetes_network_config" {
  description = "Configuration block with kubernetes network configuration for the cluster."
  type = object({
    elastic_load_balancing = optional(object({
      enabled = optional(bool)
    }))
    service_ipv4_cidr = optional(string)
    ip_family         = optional(string, "ipv4")
  })
  default = null

  validation {
    condition = var.kubernetes_network_config == null || (
      var.kubernetes_network_config.ip_family == null ||
      contains(["ipv4", "ipv6"], var.kubernetes_network_config.ip_family)
    )
    error_message = "resource_aws_eks_cluster, kubernetes_network_config ip_family must be either 'ipv4' or 'ipv6'."
  }

  validation {
    condition = var.kubernetes_network_config == null || (
      var.kubernetes_network_config.service_ipv4_cidr == null ||
      can(cidrhost(var.kubernetes_network_config.service_ipv4_cidr, 0))
    )
    error_message = "resource_aws_eks_cluster, kubernetes_network_config service_ipv4_cidr must be a valid CIDR block."
  }
}

variable "outpost_config" {
  description = "Configuration block representing the configuration of your local Amazon EKS cluster on an AWS Outpost."
  type = object({
    control_plane_instance_type = string
    control_plane_placement = optional(object({
      group_name = string
    }))
    outpost_arns = list(string)
  })
  default = null

  validation {
    condition = var.outpost_config == null || (
      length(var.outpost_config.outpost_arns) == 1
    )
    error_message = "resource_aws_eks_cluster, outpost_config outpost_arns must contain exactly one ARN."
  }

  validation {
    condition = var.outpost_config == null || (
      alltrue([for arn in var.outpost_config.outpost_arns : can(regex("^arn:aws[a-zA-Z-]*:outposts:[a-z0-9-]+:[0-9]{12}:outpost/op-[a-zA-Z0-9]+$", arn))])
    )
    error_message = "resource_aws_eks_cluster, outpost_config outpost_arns must contain valid Outpost ARNs."
  }
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "remote_network_config" {
  description = "Configuration block with remote network configuration for EKS Hybrid Nodes."
  type = object({
    remote_node_networks = optional(object({
      cidrs = list(string)
    }))
    remote_pod_networks = optional(object({
      cidrs = list(string)
    }))
  })
  default = null

  validation {
    condition = var.remote_network_config == null || (
      var.remote_network_config.remote_node_networks == null ||
      alltrue([for cidr in var.remote_network_config.remote_node_networks.cidrs : can(cidrhost(cidr, 0))])
    )
    error_message = "resource_aws_eks_cluster, remote_network_config remote_node_networks cidrs must be valid CIDR blocks."
  }

  validation {
    condition = var.remote_network_config == null || (
      var.remote_network_config.remote_pod_networks == null ||
      alltrue([for cidr in var.remote_network_config.remote_pod_networks.cidrs : can(cidrhost(cidr, 0))])
    )
    error_message = "resource_aws_eks_cluster, remote_network_config remote_pod_networks cidrs must be valid CIDR blocks."
  }
}

variable "storage_config" {
  description = "Configuration block with storage configuration for EKS Auto Mode."
  type = object({
    block_storage = optional(object({
      enabled = optional(bool)
    }))
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "upgrade_policy" {
  description = "Configuration block for the support policy to use for the cluster."
  type = object({
    support_type = optional(string)
  })
  default = null

  validation {
    condition = var.upgrade_policy == null || (
      var.upgrade_policy.support_type == null ||
      contains(["EXTENDED", "STANDARD"], var.upgrade_policy.support_type)
    )
    error_message = "resource_aws_eks_cluster, upgrade_policy support_type must be either 'EXTENDED' or 'STANDARD'."
  }
}

variable "kubernetes_version" {
  description = "Desired Kubernetes master version."
  type        = string
  default     = null

  validation {
    condition     = var.kubernetes_version == null || can(regex("^[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "resource_aws_eks_cluster, kubernetes_version must be in the format 'X.Y' (e.g., '1.31')."
  }
}

variable "zonal_shift_config" {
  description = "Configuration block with zonal shift configuration for the cluster."
  type = object({
    enabled = optional(bool)
  })
  default = null
}