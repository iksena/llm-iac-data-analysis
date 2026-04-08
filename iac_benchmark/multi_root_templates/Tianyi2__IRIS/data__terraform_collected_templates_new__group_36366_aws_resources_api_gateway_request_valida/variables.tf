variable "name" {
  description = "Name of the request validator"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_api_gateway_request_validator, name must not be empty."
  }
}

variable "rest_api_id" {
  description = "ID of the associated Rest API"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_request_validator, rest_api_id must not be empty."
  }
}

variable "validate_request_body" {
  description = "Boolean whether to validate request body"
  type        = bool
  default     = false
}

variable "validate_request_parameters" {
  description = "Boolean whether to validate request parameters"
  type        = bool
  default     = false
}