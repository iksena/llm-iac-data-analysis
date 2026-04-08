variable "id" {
  description = "Application identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.id)) && length(var.id) > 0
    error_message = "data_aws_servicecatalogappregistry_application, id must be a non-empty string containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_servicecatalogappregistry_application, region must be a valid AWS region identifier or null."
  }
}