variable "policy_name" {
  description = "Name of the resource policy. Must be unique within a specific Amazon Web Services account."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "resource_aws_xray_resource_policy, policy_name must not be empty."
  }
}

variable "policy_document" {
  description = "JSON string of the resource policy or resource policy document, which can be up to 5kb in size."
  type        = string

  validation {
    condition     = length(var.policy_document) > 0 && length(var.policy_document) <= 5120
    error_message = "resource_aws_xray_resource_policy, policy_document must not be empty and cannot exceed 5kb in size."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy_revision_id" {
  description = "Specifies a specific policy revision, to ensure an atomic create operation. By default the resource policy is created if it does not exist, or updated with an incremented revision id."
  type        = string
  default     = null
}

variable "bypass_policy_lockout_check" {
  description = "Flag to indicate whether to bypass the resource policy lockout safety check. Setting this value to true increases the risk that the policy becomes unmanageable."
  type        = bool
  default     = false
}