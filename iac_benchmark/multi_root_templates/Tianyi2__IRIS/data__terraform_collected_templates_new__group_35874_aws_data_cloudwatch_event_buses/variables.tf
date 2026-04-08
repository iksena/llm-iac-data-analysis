variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_cloudwatch_event_buses, region must be a valid AWS region identifier."
  }
}

variable "name_prefix" {
  description = "Specifying this limits the results to only those event buses with names that start with the specified prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) > 0
    error_message = "data_aws_cloudwatch_event_buses, name_prefix must be a non-empty string when specified."
  }
}