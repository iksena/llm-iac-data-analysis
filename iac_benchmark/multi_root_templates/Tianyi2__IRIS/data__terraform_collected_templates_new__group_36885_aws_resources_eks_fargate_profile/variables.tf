variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_fargate_profile, cluster_name must not be empty."
  }
}

variable "fargate_profile_name" {
  description = "Name of the EKS Fargate Profile"
  type        = string

  validation {
    condition     = length(var.fargate_profile_name) > 0
    error_message = "resource_aws_eks_fargate_profile, fargate_profile_name must not be empty."
  }
}

variable "pod_execution_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.pod_execution_role_arn))
    error_message = "resource_aws_eks_fargate_profile, pod_execution_role_arn must be a valid IAM role ARN."
  }
}

variable "selector" {
  description = "Configuration block(s) for selecting Kubernetes Pods to execute with this EKS Fargate Profile"
  type = list(object({
    namespace = string
    labels    = optional(map(string))
    region    = optional(string)
  }))

  validation {
    condition     = length(var.selector) > 0
    error_message = "resource_aws_eks_fargate_profile, selector must contain at least one block."
  }

  validation {
    condition = alltrue([
      for s in var.selector : length(s.namespace) > 0
    ])
    error_message = "resource_aws_eks_fargate_profile, selector namespace must not be empty."
  }
}

variable "subnet_ids" {
  description = "Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_eks_fargate_profile, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.subnet_ids : can(regex("^subnet-[a-zA-Z0-9]+", subnet_id))
    ])
    error_message = "resource_aws_eks_fargate_profile, subnet_ids must be valid subnet identifiers."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.timeouts_create))
    error_message = "resource_aws_eks_fargate_profile, timeouts_create must be a valid timeout string (e.g., '10m', '600s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.timeouts_delete))
    error_message = "resource_aws_eks_fargate_profile, timeouts_delete must be a valid timeout string (e.g., '10m', '600s')."
  }
}