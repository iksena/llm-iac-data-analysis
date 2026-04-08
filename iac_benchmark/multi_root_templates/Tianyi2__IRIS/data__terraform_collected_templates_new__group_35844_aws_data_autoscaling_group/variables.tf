variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_autoscaling_group, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "Specify the exact name of the desired autoscaling group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_autoscaling_group, name must be a non-empty string."
  }
}