variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "application_id" {
  type        = string
  description = "ID of the AppConfig Application to which this Environment belongs."

  validation {
    condition     = length(var.application_id) > 0
    error_message = "data_aws_appconfig_environment, application_id must not be empty."
  }
}

variable "environment_id" {
  type        = string
  description = "ID of the AppConfig Environment."

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "data_aws_appconfig_environment, environment_id must not be empty."
  }
}