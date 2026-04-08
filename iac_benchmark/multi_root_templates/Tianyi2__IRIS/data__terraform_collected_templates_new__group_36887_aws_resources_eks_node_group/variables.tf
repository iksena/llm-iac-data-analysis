variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_node_group, cluster_name must be a non-empty string."
  }
}

variable "node_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]+:role/.+", var.node_role_arn))
    error_message = "resource_aws_eks_node_group, node_role_arn must be a valid IAM role ARN."
  }
}

variable "scaling_config" {
  description = "Configuration block with scaling settings"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })

  validation {
    condition     = var.scaling_config.min_size >= 0
    error_message = "resource_aws_eks_node_group, scaling_config min_size must be >= 0."
  }

  validation {
    condition     = var.scaling_config.max_size >= var.scaling_config.min_size
    error_message = "resource_aws_eks_node_group, scaling_config max_size must be >= min_size."
  }

  validation {
    condition     = var.scaling_config.desired_size >= var.scaling_config.min_size && var.scaling_config.desired_size <= var.scaling_config.max_size
    error_message = "resource_aws_eks_node_group, scaling_config desired_size must be between min_size and max_size."
  }
}

variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Group"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_eks_node_group, subnet_ids must contain at least one subnet ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = null

  validation {
    condition = var.ami_type == null || contains([
      "AL2_x86_64",
      "AL2_x86_64_GPU",
      "AL2_ARM_64",
      "CUSTOM",
      "BOTTLEROCKET_ARM_64",
      "BOTTLEROCKET_x86_64",
      "WINDOWS_CORE_2019_x86_64",
      "WINDOWS_FULL_2019_x86_64",
      "WINDOWS_CORE_2022_x86_64",
      "WINDOWS_FULL_2022_x86_64"
    ], var.ami_type)
    error_message = "resource_aws_eks_node_group, ami_type must be a valid AMI type."
  }
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type        = string
  default     = null

  validation {
    condition     = var.capacity_type == null || contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "resource_aws_eks_node_group, capacity_type must be either ON_DEMAND or SPOT."
  }
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = null

  validation {
    condition     = var.disk_size == null || (var.disk_size > 0 && var.disk_size <= 16384)
    error_message = "resource_aws_eks_node_group, disk_size must be between 1 and 16384 GiB."
  }
}

variable "force_update_version" {
  description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue"
  type        = bool
  default     = null
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = null

  validation {
    condition     = var.instance_types == null || length(var.instance_types) > 0
    error_message = "resource_aws_eks_node_group, instance_types must contain at least one instance type when specified."
  }
}

variable "labels" {
  description = "Key-value map of Kubernetes labels"
  type        = map(string)
  default     = null
}

variable "launch_template" {
  description = "Configuration block with Launch Template settings"
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = string
  })
  default = null

  validation {
    condition = var.launch_template == null || (
      (var.launch_template.id != null && var.launch_template.name == null) ||
      (var.launch_template.id == null && var.launch_template.name != null)
    )
    error_message = "resource_aws_eks_node_group, launch_template must specify either id or name, but not both."
  }

  validation {
    condition     = var.launch_template == null || length(var.launch_template.version) > 0
    error_message = "resource_aws_eks_node_group, launch_template version must be specified."
  }
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
  default     = null

  validation {
    condition     = var.node_group_name == null || (length(var.node_group_name) <= 63 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.node_group_name)))
    error_message = "resource_aws_eks_node_group, node_group_name must be <= 63 characters and start with a letter or digit."
  }
}

variable "node_group_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null

  validation {
    condition     = var.node_group_name_prefix == null || length(var.node_group_name_prefix) > 0
    error_message = "resource_aws_eks_node_group, node_group_name_prefix must be a non-empty string when specified."
  }
}

variable "node_repair_config" {
  description = "The node auto repair configuration for the node group"
  type = object({
    enabled = bool
  })
  default = null
}

variable "release_version" {
  description = "AMI version of the EKS Node Group"
  type        = string
  default     = null
}

variable "remote_access" {
  description = "Configuration block with remote access settings"
  type = object({
    ec2_ssh_key               = optional(string)
    source_security_group_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = null
}

variable "taint" {
  description = "The Kubernetes taints to be applied to the nodes in the node group"
  type = list(object({
    key    = string
    value  = optional(string)
    effect = string
  }))
  default = null

  validation {
    condition     = var.taint == null || length(var.taint) <= 50
    error_message = "resource_aws_eks_node_group, taint can have a maximum of 50 taints per node group."
  }

  validation {
    condition = var.taint == null || alltrue([
      for t in var.taint : length(t.key) <= 63
    ])
    error_message = "resource_aws_eks_node_group, taint key must have a maximum length of 63 characters."
  }

  validation {
    condition = var.taint == null || alltrue([
      for t in var.taint : t.value == null || length(t.value) <= 63
    ])
    error_message = "resource_aws_eks_node_group, taint value must have a maximum length of 63 characters."
  }

  validation {
    condition = var.taint == null || alltrue([
      for t in var.taint : contains(["NO_SCHEDULE", "NO_EXECUTE", "PREFER_NO_SCHEDULE"], t.effect)
    ])
    error_message = "resource_aws_eks_node_group, taint effect must be one of NO_SCHEDULE, NO_EXECUTE, or PREFER_NO_SCHEDULE."
  }
}

variable "update_config" {
  description = "Configuration block with update settings"
  type = object({
    max_unavailable            = optional(number)
    max_unavailable_percentage = optional(number)
  })
  default = null

  validation {
    condition = var.update_config == null || (
      (var.update_config.max_unavailable != null && var.update_config.max_unavailable_percentage == null) ||
      (var.update_config.max_unavailable == null && var.update_config.max_unavailable_percentage != null) ||
      (var.update_config.max_unavailable == null && var.update_config.max_unavailable_percentage == null)
    )
    error_message = "resource_aws_eks_node_group, update_config max_unavailable and max_unavailable_percentage are mutually exclusive."
  }

  validation {
    condition     = var.update_config == null || var.update_config.max_unavailable == null || var.update_config.max_unavailable >= 1
    error_message = "resource_aws_eks_node_group, update_config max_unavailable must be >= 1."
  }

  validation {
    condition     = var.update_config == null || var.update_config.max_unavailable_percentage == null || (var.update_config.max_unavailable_percentage >= 1 && var.update_config.max_unavailable_percentage <= 100)
    error_message = "resource_aws_eks_node_group, update_config max_unavailable_percentage must be between 1 and 100."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = {}

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_eks_node_group, timeouts must be valid duration strings (e.g., '60m', '2h', '30s')."
  }
}