variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_scaling_configuration_arn" {
  description = "The ARN of the App Runner auto scaling configuration that you want to set as the default."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:apprunner:", var.auto_scaling_configuration_arn))
    error_message = "resource_aws_apprunner_default_auto_scaling_configuration_version, auto_scaling_configuration_arn must be a valid App Runner auto scaling configuration ARN starting with 'arn:aws:apprunner:'."
  }
}