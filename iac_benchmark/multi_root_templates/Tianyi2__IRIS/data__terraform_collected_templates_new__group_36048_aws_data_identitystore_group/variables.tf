variable "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance"
  type        = string

  validation {
    condition     = length(var.identity_store_id) > 0
    error_message = "data_identitystore_group, identity_store_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "alternate_identifier" {
  description = "A unique identifier for the group that is not the primary identifier"
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
      (var.alternate_identifier.external_id != null ? 1 : 0) +
      (var.alternate_identifier.unique_attribute != null ? 1 : 0) == 1
    )
    error_message = "data_identitystore_group, alternate_identifier must have exactly one of external_id or unique_attribute specified."
  }

  validation {
    condition = var.alternate_identifier == null || var.alternate_identifier.external_id == null || (
      length(var.alternate_identifier.external_id.id) > 0 &&
      length(var.alternate_identifier.external_id.issuer) > 0
    )
    error_message = "data_identitystore_group, alternate_identifier external_id id and issuer must not be empty when specified."
  }

  validation {
    condition = var.alternate_identifier == null || var.alternate_identifier.unique_attribute == null || (
      length(var.alternate_identifier.unique_attribute.attribute_path) > 0 &&
      length(var.alternate_identifier.unique_attribute.attribute_value) > 0
    )
    error_message = "data_identitystore_group, alternate_identifier unique_attribute attribute_path and attribute_value must not be empty when specified."
  }
}

variable "group_id" {
  description = "The identifier for a group in the Identity Store"
  type        = string
  default     = null

  validation {
    condition     = var.group_id == null || length(var.group_id) > 0
    error_message = "data_identitystore_group, group_id must not be empty when specified."
  }
}