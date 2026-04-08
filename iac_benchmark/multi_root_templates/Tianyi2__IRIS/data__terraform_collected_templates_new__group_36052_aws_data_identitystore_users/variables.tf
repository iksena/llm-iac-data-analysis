variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_identitystore_users, region must be a valid AWS region format or null."
  }
}

variable "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance."
  type        = string

  validation {
    condition     = length(var.identity_store_id) > 0
    error_message = "data_aws_identitystore_users, identity_store_id cannot be empty."
  }

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.identity_store_id))
    error_message = "data_aws_identitystore_users, identity_store_id must be in format 'd-xxxxxxxxxx'."
  }
}