variable "application_id" {
  description = "ID of the AppConfig Application"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{4,7}$", var.application_id))
    error_message = "data_aws_appconfig_configuration_profiles, application_id must be a valid AppConfig Application ID (4-7 alphanumeric characters)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_appconfig_configuration_profiles, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}