variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the log stream. Must not be longer than 512 characters and must not contain ':'."
  type        = string

  validation {
    condition     = length(var.name) <= 512
    error_message = "resource_aws_cloudwatch_log_stream, name must not be longer than 512 characters."
  }

  validation {
    condition     = !can(regex(":", var.name))
    error_message = "resource_aws_cloudwatch_log_stream, name must not contain ':'."
  }
}

variable "log_group_name" {
  description = "The name of the log group under which the log stream is to be created."
  type        = string
}