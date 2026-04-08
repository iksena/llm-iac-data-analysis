variable "http_method" {
  description = "HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = string

  validation {
    condition     = contains(["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "ANY"], var.http_method)
    error_message = "resource_aws_api_gateway_integration_response, http_method must be one of: GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY."
  }
}

variable "resource_id" {
  description = "API resource ID"
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_api_gateway_integration_response, resource_id must not be empty."
  }
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_integration_response, rest_api_id must not be empty."
  }
}

variable "status_code" {
  description = "HTTP status code"
  type        = string

  validation {
    condition     = can(regex("^[1-5][0-9]{2}$", var.status_code))
    error_message = "resource_aws_api_gateway_integration_response, status_code must be a valid HTTP status code (100-599)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "content_handling" {
  description = "How to handle request payload content type conversions. Supported values are CONVERT_TO_BINARY and CONVERT_TO_TEXT"
  type        = string
  default     = null

  validation {
    condition     = var.content_handling == null || contains(["CONVERT_TO_BINARY", "CONVERT_TO_TEXT"], var.content_handling)
    error_message = "resource_aws_api_gateway_integration_response, content_handling must be either CONVERT_TO_BINARY or CONVERT_TO_TEXT."
  }
}

variable "response_parameters" {
  description = "Map of response parameters that can be read from the backend response"
  type        = map(string)
  default     = null
}

variable "response_templates" {
  description = "Map of templates used to transform the integration response body"
  type        = map(string)
  default     = null
}

variable "selection_pattern" {
  description = "Regular expression pattern used to choose an integration response based on the response from the backend"
  type        = string
  default     = null
}