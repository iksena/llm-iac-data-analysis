variable "authentication_type" {
  description = "Authentication type for the user. You must specify USERPOOL. Valid values: API, SAML, USERPOOL"
  type        = string

  validation {
    condition     = contains(["API", "SAML", "USERPOOL"], var.authentication_type)
    error_message = "resource_aws_appstream_user, authentication_type must be one of: API, SAML, USERPOOL."
  }
}

variable "user_name" {
  description = "Email address of the user"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the user in the user pool is enabled"
  type        = bool
  default     = null
}

variable "first_name" {
  description = "First name, or given name, of the user"
  type        = string
  default     = null
}

variable "last_name" {
  description = "Last name, or surname, of the user"
  type        = string
  default     = null
}

variable "send_email_notification" {
  description = "Send an email notification"
  type        = bool
  default     = null
}