variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identifier" {
  description = "An identifier for the resource server."
  type        = string

  validation {
    condition     = length(var.identifier) > 0
    error_message = "resource_aws_cognito_resource_server, identifier must not be empty."
  }
}

variable "name" {
  description = "A name for the resource server."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cognito_resource_server, name must not be empty."
  }
}

variable "user_pool_id" {
  description = "User pool the client belongs to."
  type        = string

  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "resource_aws_cognito_resource_server, user_pool_id must not be empty."
  }
}

variable "scope" {
  description = "A list of Authorization Scope."
  type = list(object({
    scope_name        = string
    scope_description = string
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.scope : length(s.scope_name) > 0
    ])
    error_message = "resource_aws_cognito_resource_server, scope scope_name must not be empty."
  }

  validation {
    condition = alltrue([
      for s in var.scope : length(s.scope_description) > 0
    ])
    error_message = "resource_aws_cognito_resource_server, scope scope_description must not be empty."
  }
}