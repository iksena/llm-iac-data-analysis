variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_model, rest_api_id must not be empty."
  }
}

variable "name" {
  description = "Name of the model"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_api_gateway_model, name must not be empty."
  }
}

variable "description" {
  description = "Description of the model"
  type        = string
  default     = null
}

variable "content_type" {
  description = "Content type of the model"
  type        = string

  validation {
    condition     = length(var.content_type) > 0
    error_message = "resource_aws_api_gateway_model, content_type must not be empty."
  }
}

variable "schema" {
  description = "Schema of the model in a JSON form"
  type        = string

  validation {
    condition     = length(var.schema) > 0
    error_message = "resource_aws_api_gateway_model, schema must not be empty."
  }
}