variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authentication_profile_name" {
  description = "The name of the authentication profile."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.authentication_profile_name))
    error_message = "resource_aws_redshift_authentication_profile, authentication_profile_name must contain only alphanumeric characters, underscores, and hyphens."
  }

  validation {
    condition     = length(var.authentication_profile_name) > 0 && length(var.authentication_profile_name) <= 255
    error_message = "resource_aws_redshift_authentication_profile, authentication_profile_name must be between 1 and 255 characters in length."
  }
}

variable "authentication_profile_content" {
  description = "The content of the authentication profile in JSON format. The maximum length of the JSON string is determined by a quota for your account."
  type        = string

  validation {
    condition     = can(jsondecode(var.authentication_profile_content))
    error_message = "resource_aws_redshift_authentication_profile, authentication_profile_content must be valid JSON format."
  }

  validation {
    condition     = length(var.authentication_profile_content) > 0
    error_message = "resource_aws_redshift_authentication_profile, authentication_profile_content cannot be empty."
  }
}