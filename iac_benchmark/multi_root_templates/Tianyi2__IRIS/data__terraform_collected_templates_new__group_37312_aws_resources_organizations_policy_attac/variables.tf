variable "policy_id" {
  description = "The unique identifier (ID) of the policy that you want to attach to the target."
  type        = string

  validation {
    condition     = length(var.policy_id) > 0
    error_message = "resource_aws_organizations_policy_attachment, policy_id must be a non-empty string."
  }

  validation {
    condition     = can(regex("^p-[0-9a-zA-Z]{8,128}$", var.policy_id))
    error_message = "resource_aws_organizations_policy_attachment, policy_id must be a valid AWS Organizations policy ID starting with 'p-' followed by 8-128 alphanumeric characters."
  }
}

variable "target_id" {
  description = "The unique identifier (ID) of the root, organizational unit, or account number that you want to attach the policy to."
  type        = string

  validation {
    condition     = length(var.target_id) > 0
    error_message = "resource_aws_organizations_policy_attachment, target_id must be a non-empty string."
  }

  validation {
    condition     = can(regex("^(r-[0-9a-zA-Z]{4,32}|ou-[0-9a-zA-Z]{4,32}-[0-9a-zA-Z]{8,32}|[0-9]{12})$", var.target_id))
    error_message = "resource_aws_organizations_policy_attachment, target_id must be a valid AWS Organizations root ID (r-), organizational unit ID (ou-), or 12-digit account number."
  }
}

variable "skip_destroy" {
  description = "If set to true, destroy will not detach the policy and instead just remove the resource from state. This can be useful in situations where the attachment must be preserved to meet the AWS minimum requirement of 1 attached policy."
  type        = bool
  default     = false
}