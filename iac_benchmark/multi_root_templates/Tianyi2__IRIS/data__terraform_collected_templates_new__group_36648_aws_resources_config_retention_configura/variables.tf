variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "retention_period_in_days" {
  description = "The number of days AWS Config stores historical information."
  type        = number

  validation {
    condition     = var.retention_period_in_days > 0
    error_message = "resource_aws_config_retention_configuration, retention_period_in_days must be greater than 0."
  }
}