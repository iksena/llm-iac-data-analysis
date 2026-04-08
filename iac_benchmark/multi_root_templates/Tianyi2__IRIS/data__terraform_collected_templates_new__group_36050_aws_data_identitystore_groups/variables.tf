variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On (SSO) Instance."
  type        = string

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$|^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.identity_store_id))
    error_message = "data_identitystore_groups, identity_store_id must be a valid Identity Store ID format."
  }

  validation {
    condition     = length(var.identity_store_id) > 0
    error_message = "data_identitystore_groups, identity_store_id cannot be empty."
  }
}