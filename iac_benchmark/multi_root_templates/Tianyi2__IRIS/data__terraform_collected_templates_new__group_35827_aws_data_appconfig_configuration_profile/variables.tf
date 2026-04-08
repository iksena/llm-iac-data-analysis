variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "ID of the AppConfig application to which this configuration profile belongs."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{4,7}$", var.application_id))
    error_message = "data_aws_appconfig_configuration_profile, application_id must be a valid AppConfig application ID (4-7 alphanumeric characters)."
  }
}

variable "configuration_profile_id" {
  description = "ID of the Configuration Profile."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{4,7}$", var.configuration_profile_id))
    error_message = "data_aws_appconfig_configuration_profile, configuration_profile_id must be a valid AppConfig configuration profile ID (4-7 alphanumeric characters)."
  }
}