variable "cluster_arn" {
  description = "The Amazon Resource Name (ARN) that uniquely identifies the cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kafka:[^:]+:[0-9]{12}:cluster/.+", var.cluster_arn))
    error_message = "resource_aws_msk_cluster_policy, cluster_arn must be a valid MSK cluster ARN."
  }
}

variable "policy" {
  description = "Resource policy for cluster."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_msk_cluster_policy, policy must be a valid JSON string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_msk_cluster_policy, region must be a valid AWS region identifier."
  }
}