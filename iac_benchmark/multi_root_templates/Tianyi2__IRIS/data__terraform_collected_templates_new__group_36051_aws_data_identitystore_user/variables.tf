variable "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$", var.identity_store_id))
    error_message = "data_identitystore_user, identity_store_id must be a valid UUID format."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_identitystore_user, region must be a valid AWS region identifier."
  }
}

variable "alternate_identifier" {
  description = "A unique identifier for a user or group that is not the primary identifier. Conflicts with user_id"
  type = object({
    external_id = optional(object({
      id     = string
      issuer = string
    }))
    unique_attribute = optional(object({
      attribute_path  = string
      attribute_value = string
    }))
  })
  default = null

  validation {
    condition = var.alternate_identifier == null || (
      (var.alternate_identifier.external_id != null && var.alternate_identifier.unique_attribute == null) ||
      (var.alternate_identifier.external_id == null && var.alternate_identifier.unique_attribute != null)
    )
    error_message = "data_identitystore_user, alternate_identifier exactly one of external_id or unique_attribute must be provided."
  }

  validation {
    condition = var.alternate_identifier == null || var.alternate_identifier.external_id == null || (
      can(regex("^.+$", var.alternate_identifier.external_id.id)) &&
      can(regex("^.+$", var.alternate_identifier.external_id.issuer))
    )
    error_message = "data_identitystore_user, alternate_identifier external_id requires both id and issuer to be non-empty strings."
  }

  validation {
    condition = var.alternate_identifier == null || var.alternate_identifier.unique_attribute == null || (
      can(regex("^.+$", var.alternate_identifier.unique_attribute.attribute_path)) &&
      can(regex("^.+$", var.alternate_identifier.unique_attribute.attribute_value))
    )
    error_message = "data_identitystore_user, alternate_identifier unique_attribute requires both attribute_path and attribute_value to be non-empty strings."
  }
}

variable "user_id" {
  description = "The identifier for a user in the Identity Store"
  type        = string
  default     = null

  validation {
    condition     = var.user_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$", var.user_id))
    error_message = "data_identitystore_user, user_id must be a valid UUID format."
  }
}