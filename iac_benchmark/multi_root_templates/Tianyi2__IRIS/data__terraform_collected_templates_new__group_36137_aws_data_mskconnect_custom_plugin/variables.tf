variable "name" {
  description = "Name of the custom plugin"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "data_aws_mskconnect_custom_plugin, name must contain only alphanumeric characters and hyphens."
  }

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "data_aws_mskconnect_custom_plugin, name must be between 1 and 128 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_mskconnect_custom_plugin, region must be a valid AWS region format."
  }
}