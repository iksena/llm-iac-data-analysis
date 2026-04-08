variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_access_entry, cluster_name must not be empty."
  }
}

variable "principal_arn" {
  description = "The IAM Principal ARN which requires Authentication access to the EKS cluster"
  type        = string

  validation {
    condition     = length(var.principal_arn) > 0 && can(regex("^arn:aws", var.principal_arn))
    error_message = "resource_aws_eks_access_entry, principal_arn must be a valid ARN starting with 'arn:aws'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "kubernetes_groups" {
  description = "List of string which can optionally specify the Kubernetes groups the user would belong to when creating an access entry"
  type        = list(string)
  default     = null

  validation {
    condition     = var.kubernetes_groups == null || length(var.kubernetes_groups) > 0
    error_message = "resource_aws_eks_access_entry, kubernetes_groups must be null or contain at least one group."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = null
}

variable "type" {
  description = "Defaults to STANDARD which provides the standard workflow. EC2_LINUX, EC2_WINDOWS, FARGATE_LINUX types disallow users to input a username or groups, and prevent associations"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EC2_LINUX", "EC2_WINDOWS", "FARGATE_LINUX"], var.type)
    error_message = "resource_aws_eks_access_entry, type must be one of: STANDARD, EC2_LINUX, EC2_WINDOWS, FARGATE_LINUX."
  }
}

variable "user_name" {
  description = "Defaults to principal ARN if user is principal else defaults to assume-role/session-name is role is used"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "20m")
    delete = optional(string, "40m")
  })
  default = {
    create = "20m"
    delete = "40m"
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.create)) && can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    error_message = "resource_aws_eks_access_entry, timeouts must be valid duration strings (e.g., '20m', '1h', '30s')."
  }
}