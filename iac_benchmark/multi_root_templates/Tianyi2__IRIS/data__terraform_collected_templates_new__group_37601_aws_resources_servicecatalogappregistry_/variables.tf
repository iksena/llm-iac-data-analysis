variable "name" {
  description = "Name of the application. The name must be unique within an AWS region."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.name))
    error_message = "resource_aws_servicecatalogappregistry_application, name must start with alphanumeric character and contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "description" {
  description = "Description of the application."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_servicecatalogappregistry_application, description must be 1024 characters or less."
  }
}

variable "tags" {
  description = "A map of tags assigned to the Application. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", k)) && can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", v))])
    error_message = "resource_aws_servicecatalogappregistry_application, tags keys and values must contain only valid characters (alphanumeric, spaces, and the characters _.:/=+-@)."
  }
}