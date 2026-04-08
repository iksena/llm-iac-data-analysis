variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the EKS Cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_access_policy_association, cluster_name must be a non-empty string."
  }
}

variable "policy_arn" {
  description = "The ARN of the access policy that you're associating."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:eks::", var.policy_arn))
    error_message = "resource_aws_eks_access_policy_association, policy_arn must be a valid EKS access policy ARN starting with 'arn:aws:eks::'."
  }
}

variable "principal_arn" {
  description = "The IAM Principal ARN which requires Authentication access to the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.principal_arn))
    error_message = "resource_aws_eks_access_policy_association, principal_arn must be a valid AWS ARN starting with 'arn:aws:'."
  }
}

variable "access_scope_type" {
  description = "Valid values are namespace or cluster."
  type        = string

  validation {
    condition     = contains(["namespace", "cluster"], var.access_scope_type)
    error_message = "resource_aws_eks_access_policy_association, access_scope_type must be either 'namespace' or 'cluster'."
  }
}

variable "access_scope_namespaces" {
  description = "The namespaces to which the access scope applies when type is namespace."
  type        = list(string)
  default     = null

  validation {
    condition = var.access_scope_type == "namespace" ? (
      var.access_scope_namespaces != null && length(var.access_scope_namespaces) > 0
    ) : true
    error_message = "resource_aws_eks_access_policy_association, access_scope_namespaces is required when access_scope_type is 'namespace'."
  }
}

variable "timeouts" {
  description = "Configuration for operation timeouts."
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "40m")
  })
  default = null
}