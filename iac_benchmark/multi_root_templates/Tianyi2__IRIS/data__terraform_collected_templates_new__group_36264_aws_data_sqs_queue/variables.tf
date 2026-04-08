variable "name" {
  description = "Name of the queue to match"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name)) && length(var.name) > 0 && length(var.name) <= 80
    error_message = "data_aws_sqs_queue, name must be a valid SQS queue name (1-80 characters, alphanumeric, hyphens, and underscores only)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_sqs_queue, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}