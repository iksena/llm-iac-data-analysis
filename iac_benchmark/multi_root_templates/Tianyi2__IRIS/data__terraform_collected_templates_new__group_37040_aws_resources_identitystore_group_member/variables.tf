variable "identity_store_id" {
  type        = string
  description = "Identity Store ID associated with the Single Sign-On Instance."

  validation {
    condition     = can(regex("^d-[0-9a-zA-Z]{10}$", var.identity_store_id))
    error_message = "resource_aws_identitystore_group_membership, identity_store_id must be a valid Identity Store ID format (d-xxxxxxxxxx)."
  }
}

variable "group_id" {
  type        = string
  description = "The identifier for a group in the Identity Store."

  validation {
    condition     = length(var.group_id) > 0
    error_message = "resource_aws_identitystore_group_membership, group_id cannot be empty."
  }
}

variable "member_id" {
  type        = string
  description = "The identifier for a user in the Identity Store."

  validation {
    condition     = length(var.member_id) > 0
    error_message = "resource_aws_identitystore_group_membership, member_id cannot be empty."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}