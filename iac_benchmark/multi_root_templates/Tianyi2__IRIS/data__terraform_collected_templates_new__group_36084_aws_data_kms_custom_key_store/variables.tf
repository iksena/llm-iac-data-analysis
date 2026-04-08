variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_kms_custom_key_store, region must be a valid AWS region format."
  }
}

variable "custom_key_store_id" {
  description = "The ID for the custom key store."
  type        = string
  default     = null

  validation {
    condition     = var.custom_key_store_id == null || can(regex("^[a-zA-Z0-9-]+$", var.custom_key_store_id))
    error_message = "data_aws_kms_custom_key_store, custom_key_store_id must be a valid custom key store ID format."
  }
}

variable "custom_key_store_name" {
  description = "The user-specified friendly name for the custom key store."
  type        = string
  default     = null

  validation {
    condition     = var.custom_key_store_name == null || length(var.custom_key_store_name) > 0
    error_message = "data_aws_kms_custom_key_store, custom_key_store_name must not be empty if provided."
  }
}