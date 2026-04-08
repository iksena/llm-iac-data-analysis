variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "The string identifier of the associated REST API"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id))
    error_message = "resource_aws_api_gateway_method_response, rest_api_id must be a valid API Gateway REST API ID (lowercase alphanumeric characters only)."
  }
}

variable "resource_id" {
  description = "The Resource identifier for the method resource"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_id))
    error_message = "resource_aws_api_gateway_method_response, resource_id must be a valid API Gateway resource ID (lowercase alphanumeric characters only)."
  }
}

variable "http_method" {
  description = "The HTTP verb of the method resource"
  type        = string

  validation {
    condition     = contains(["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "ANY"], var.http_method)
    error_message = "resource_aws_api_gateway_method_response, http_method must be one of: GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY."
  }
}

variable "status_code" {
  description = "The method response's status code"
  type        = string

  validation {
    condition     = can(regex("^[1-5][0-9][0-9]$", var.status_code))
    error_message = "resource_aws_api_gateway_method_response, status_code must be a valid HTTP status code (3-digit number starting with 1-5)."
  }
}

variable "response_models" {
  description = "A map specifying the model resources used for the response's content type"
  type        = map(string)
  default     = null
}

variable "response_parameters" {
  description = "A map specifying required or optional response parameters that API Gateway can send back to the caller"
  type        = map(bool)
  default     = null

  validation {
    condition = var.response_parameters == null ? true : alltrue([
      for key in keys(var.response_parameters) : can(regex("^method\\.response\\.header\\..+$", key)) || can(regex("^method-response-header\\..+$", key))
    ])
    error_message = "resource_aws_api_gateway_method_response, response_parameters keys must match the pattern 'method.response.header.{name}' or 'method-response-header.{name}'."
  }
}