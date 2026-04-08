variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "default_log_level" {
  description = "The default logging level. Valid Values: DEBUG, INFO, ERROR, WARN, DISABLED."
  type        = string
  default     = null
  validation {
    condition = var.default_log_level == null ? true : contains([
      "DEBUG",
      "INFO",
      "ERROR",
      "WARN",
      "DISABLED"
    ], var.default_log_level)
    error_message = "resource_aws_iot_logging_options, default_log_level must be one of: DEBUG, INFO, ERROR, WARN, DISABLED."
  }
}

variable "disable_all_logs" {
  description = "If true all logs are disabled. The default is false."
  type        = bool
  default     = false
  validation {
    condition     = can(tobool(var.disable_all_logs))
    error_message = "resource_aws_iot_logging_options, disable_all_logs must be a boolean value."
  }
}

variable "role_arn" {
  description = "The ARN of the role that allows IoT to write to Cloudwatch logs."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_iot_logging_options, role_arn must be a valid IAM role ARN."
  }
}