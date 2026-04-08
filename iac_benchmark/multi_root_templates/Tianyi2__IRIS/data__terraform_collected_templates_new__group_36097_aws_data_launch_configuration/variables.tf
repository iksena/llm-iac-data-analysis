variable "name" {
  description = "Name of the launch configuration"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_launch_configuration, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_launch_configuration, region must not be empty if specified."
  }
}