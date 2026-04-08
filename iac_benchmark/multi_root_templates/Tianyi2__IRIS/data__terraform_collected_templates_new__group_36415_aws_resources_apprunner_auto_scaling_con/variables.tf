variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null
}

variable "auto_scaling_configuration_name" {
  type        = string
  description = "Name of the auto scaling configuration"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.auto_scaling_configuration_name))
    error_message = "resource_aws_apprunner_auto_scaling_configuration_version, auto_scaling_configuration_name must be a valid configuration name."
  }
}

variable "max_concurrency" {
  type        = number
  description = "Maximal number of concurrent requests that you want an instance to process"
  default     = null

  validation {
    condition     = var.max_concurrency == null || (var.max_concurrency >= 1 && var.max_concurrency <= 1000)
    error_message = "resource_aws_apprunner_auto_scaling_configuration_version, max_concurrency must be between 1 and 1000."
  }
}

variable "max_size" {
  type        = number
  description = "Maximal number of instances that App Runner provisions for your service"
  default     = null

  validation {
    condition     = var.max_size == null || (var.max_size >= 1 && var.max_size <= 1000)
    error_message = "resource_aws_apprunner_auto_scaling_configuration_version, max_size must be between 1 and 1000."
  }
}

variable "min_size" {
  type        = number
  description = "Minimal number of instances that App Runner provisions for your service"
  default     = null

  validation {
    condition     = var.min_size == null || (var.min_size >= 1 && var.min_size <= 25)
    error_message = "resource_aws_apprunner_auto_scaling_configuration_version, min_size must be between 1 and 25."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of resource tags"
  default     = {}
}