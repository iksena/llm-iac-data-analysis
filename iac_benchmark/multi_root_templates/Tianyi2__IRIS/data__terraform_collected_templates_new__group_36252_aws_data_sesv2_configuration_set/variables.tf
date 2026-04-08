variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "configuration_set_name" {
  description = "The name of the configuration set."
  type        = string

  validation {
    condition     = var.configuration_set_name != null && var.configuration_set_name != ""
    error_message = "data_aws_sesv2_configuration_set, configuration_set_name cannot be null or empty."
  }
}