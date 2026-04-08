variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_identitystore_group_memberships, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "group_id" {
  description = "The identifier for a group in the Identity Store."
  type        = string

  validation {
    condition     = length(var.group_id) > 0
    error_message = "data_aws_identitystore_group_memberships, group_id must be a non-empty string."
  }
}

variable "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance."
  type        = string

  validation {
    condition     = length(var.identity_store_id) > 0
    error_message = "data_aws_identitystore_group_memberships, identity_store_id must be a non-empty string."
  }
}