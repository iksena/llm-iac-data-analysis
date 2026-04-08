variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "key_id" {
  description = "The ID of the KMS Key to attach the policy."
  type        = string

  validation {
    condition     = var.key_id != null && var.key_id != ""
    error_message = "resource_aws_kms_key_policy, key_id cannot be null or empty."
  }
}

variable "policy" {
  description = "A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used."
  type        = string

  validation {
    condition     = var.policy != null && var.policy != ""
    error_message = "resource_aws_kms_key_policy, policy cannot be null or empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_kms_key_policy, policy must be a valid JSON document."
  }
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable."
  type        = bool
  default     = false
}