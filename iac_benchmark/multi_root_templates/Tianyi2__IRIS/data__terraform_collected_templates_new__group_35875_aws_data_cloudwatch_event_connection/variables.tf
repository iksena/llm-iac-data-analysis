variable "name" {
  description = "Name of the connection"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) >= 1 && length(var.name) <= 64
    error_message = "data_aws_cloudwatch_event_connection, name must be between 1 and 64 characters and contain only alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_cloudwatch_event_connection, region must be a valid AWS region identifier (e.g., us-east-1, eu-west-1)."
  }
}