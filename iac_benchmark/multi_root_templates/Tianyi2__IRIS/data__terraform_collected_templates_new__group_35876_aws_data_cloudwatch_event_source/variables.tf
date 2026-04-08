variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.region))
    error_message = "data_aws_cloudwatch_event_source, region must be a valid AWS region format (e.g., us-east-1, eu-west-1a)."
  }
}

variable "name_prefix" {
  description = "Specifying this limits the results to only those partner event sources with names that start with the specified prefix"
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) > 0
    error_message = "data_aws_cloudwatch_event_source, name_prefix must be a non-empty string when specified."
  }
}