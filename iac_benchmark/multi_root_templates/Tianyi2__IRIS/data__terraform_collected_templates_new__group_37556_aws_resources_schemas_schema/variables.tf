variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the schema. Maximum of 385 characters consisting of lower case letters, upper case letters, ., -, _, @."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._@-]{1,385}$", var.name))
    error_message = "resource_aws_schemas_schema, name must be maximum 385 characters consisting of lower case letters, upper case letters, ., -, _, @."
  }
}

variable "content" {
  description = "The schema specification. Must be a valid Open API 3.0 spec."
  type        = string

  validation {
    condition     = length(var.content) > 0
    error_message = "resource_aws_schemas_schema, content must be a non-empty string containing a valid Open API 3.0 spec."
  }
}

variable "registry_name" {
  description = "The name of the registry in which this schema belongs."
  type        = string

  validation {
    condition     = length(var.registry_name) > 0
    error_message = "resource_aws_schemas_schema, registry_name must be a non-empty string."
  }
}

variable "type" {
  description = "The type of the schema. Valid values: OpenApi3 or JSONSchemaDraft4."
  type        = string

  validation {
    condition     = contains(["OpenApi3", "JSONSchemaDraft4"], var.type)
    error_message = "resource_aws_schemas_schema, type must be either 'OpenApi3' or 'JSONSchemaDraft4'."
  }
}

variable "description" {
  description = "The description of the schema. Maximum of 256 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 256
    error_message = "resource_aws_schemas_schema, description must be maximum 256 characters."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}