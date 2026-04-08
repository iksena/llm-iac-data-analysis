variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "API identifier."
  type        = string

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_apigatewayv2_model, api_id must be a non-empty string."
  }
}

variable "content_type" {
  description = "The content-type for the model, for example, application/json. Must be between 1 and 256 characters in length."
  type        = string

  validation {
    condition     = length(var.content_type) >= 1 && length(var.content_type) <= 256
    error_message = "resource_aws_apigatewayv2_model, content_type must be between 1 and 256 characters in length."
  }
}

variable "name" {
  description = "Name of the model. Must be alphanumeric. Must be between 1 and 128 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_apigatewayv2_model, name must be between 1 and 128 characters in length."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.name))
    error_message = "resource_aws_apigatewayv2_model, name must be alphanumeric."
  }
}

variable "schema" {
  description = "Schema for the model. This should be a JSON schema draft 4 model. Must be less than or equal to 32768 characters in length."
  type        = string

  validation {
    condition     = length(var.schema) <= 32768
    error_message = "resource_aws_apigatewayv2_model, schema must be less than or equal to 32768 characters in length."
  }

  validation {
    condition     = length(var.schema) > 0
    error_message = "resource_aws_apigatewayv2_model, schema must be a non-empty string."
  }
}

variable "description" {
  description = "Description of the model. Must be between 1 and 128 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 1 && length(var.description) <= 128)
    error_message = "resource_aws_apigatewayv2_model, description must be between 1 and 128 characters in length when provided."
  }
}