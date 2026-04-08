variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_mskconnect_connector, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "name" {
  description = "Name of the connector."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_mskconnect_connector, name cannot be null or empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "data_aws_mskconnect_connector, name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.name) <= 128
    error_message = "data_aws_mskconnect_connector, name must be 128 characters or less."
  }
}