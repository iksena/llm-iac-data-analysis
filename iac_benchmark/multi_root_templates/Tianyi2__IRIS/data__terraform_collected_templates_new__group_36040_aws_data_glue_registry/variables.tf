variable "name" {
  description = "Name of the Glue Registry"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_glue_registry, name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_glue_registry, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}