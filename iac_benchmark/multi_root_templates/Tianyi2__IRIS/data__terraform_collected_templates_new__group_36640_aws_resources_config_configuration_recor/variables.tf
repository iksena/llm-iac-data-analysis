variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]{1}$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^cn-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_config_configuration_recorder_status, region must be a valid AWS region format (e.g., us-east-1, eu-west-1, ap-southeast-2)."
  }
}

variable "name" {
  description = "The name of the recorder."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_config_configuration_recorder_status, name must be a non-empty string."
  }
}

variable "is_enabled" {
  description = "Whether the configuration recorder should be enabled or disabled."
  type        = bool
}