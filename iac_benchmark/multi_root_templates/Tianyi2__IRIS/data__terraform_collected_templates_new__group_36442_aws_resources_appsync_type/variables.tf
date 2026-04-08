variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "GraphQL API ID."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.api_id))
    error_message = "resource_aws_appsync_type, api_id must be a valid GraphQL API ID containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "format" {
  description = "The type format: SDL or JSON."
  type        = string

  validation {
    condition     = contains(["SDL", "JSON"], var.format)
    error_message = "resource_aws_appsync_type, format must be either 'SDL' or 'JSON'."
  }
}

variable "definition" {
  description = "The type definition."
  type        = string

  validation {
    condition     = length(trimspace(var.definition)) > 0
    error_message = "resource_aws_appsync_type, definition cannot be empty or contain only whitespace."
  }
}