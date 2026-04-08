variable "name" {
  description = "Name of the export as it appears in the console or from list-exports"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_cloudformation_export, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_cloudformation_export, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}