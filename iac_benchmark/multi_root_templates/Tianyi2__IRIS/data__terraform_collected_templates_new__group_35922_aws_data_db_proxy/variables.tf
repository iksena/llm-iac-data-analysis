variable "name" {
  description = "Name of the DB proxy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_db_proxy, name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_db_proxy, region must be a valid AWS region format (lowercase letters, numbers, and hyphens only)."
  }
}