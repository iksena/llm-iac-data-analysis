variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "ARN of the private CA to associate with the policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm-pca:", var.resource_arn))
    error_message = "resource_aws_acmpca_policy, resource_arn must be a valid ACM PCA ARN starting with 'arn:aws:acm-pca:'."
  }
}

variable "policy" {
  description = "JSON-formatted IAM policy to attach to the specified private CA resource."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_acmpca_policy, policy must be valid JSON."
  }
}