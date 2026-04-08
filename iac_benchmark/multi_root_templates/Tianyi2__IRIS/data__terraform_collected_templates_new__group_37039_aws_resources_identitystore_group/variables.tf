variable "identity_store_id" {
  description = "The globally unique identifier for the identity store."
  type        = string

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.identity_store_id))
    error_message = "resource_aws_identitystore_group, identity_store_id must be a valid identity store ID format (d- followed by 10 hexadecimal characters)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_identitystore_group, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "display_name" {
  description = "A string containing the name of the group. This value is commonly displayed when the group is referenced."
  type        = string
  default     = null

  validation {
    condition     = var.display_name == null || (length(var.display_name) >= 1 && length(var.display_name) <= 1024)
    error_message = "resource_aws_identitystore_group, display_name must be between 1 and 1024 characters long."
  }
}

variable "description" {
  description = "A string containing the description of the group."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_identitystore_group, description must not exceed 1024 characters."
  }
}

