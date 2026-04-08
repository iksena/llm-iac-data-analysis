variable "user_pool_id" {
  description = "The user pool ID for the user pool where the user will be created"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]+$", var.user_pool_id))
    error_message = "resource_aws_cognito_user, user_pool_id must be a valid user pool ID."
  }
}

variable "username" {
  description = "The username for the user. Must be unique within the user pool. Must be a UTF-8 string between 1 and 128 characters"
  type        = string

  validation {
    condition     = length(var.username) >= 1 && length(var.username) <= 128
    error_message = "resource_aws_cognito_user, username must be between 1 and 128 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "attributes" {
  description = "A map that contains user attributes and attribute values to be set for the user"
  type        = map(any)
  default     = {}
}

variable "client_metadata" {
  description = "A map of custom key-value pairs for custom workflows triggered by user creation"
  type        = map(string)
  default     = {}
}

variable "desired_delivery_mediums" {
  description = "A list of mediums to send the welcome message through. Allowed values are EMAIL and SMS"
  type        = list(string)
  default     = ["SMS"]

  validation {
    condition = alltrue([
      for medium in var.desired_delivery_mediums : contains(["EMAIL", "SMS"], medium)
    ])
    error_message = "resource_aws_cognito_user, desired_delivery_mediums must contain only EMAIL and/or SMS values."
  }
}

variable "enabled" {
  description = "Specifies whether the user should be enabled after creation"
  type        = bool
  default     = true
}

variable "force_alias_creation" {
  description = "If set to true, migrate alias from previous user if phone_number or email already exists as an alias"
  type        = bool
  default     = false
}

variable "message_action" {
  description = "Set to RESEND to resend invitation or SUPPRESS to suppress sending the message"
  type        = string
  default     = null

  validation {
    condition     = var.message_action == null || contains(["RESEND", "SUPPRESS"], var.message_action)
    error_message = "resource_aws_cognito_user, message_action must be either RESEND or SUPPRESS."
  }
}

variable "password" {
  description = "The user's permanent password. Must conform to password policy. Conflicts with temporary_password"
  type        = string
  default     = null
  sensitive   = true
}

variable "temporary_password" {
  description = "The user's temporary password. Conflicts with password"
  type        = string
  default     = null
  sensitive   = true
}

variable "validation_data" {
  description = "The user's validation data for custom validation workflows"
  type        = map(string)
  default     = {}
}