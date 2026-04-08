variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "REST API id that owns the resource"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "data_aws_api_gateway_resource, rest_api_id must be a non-empty string."
  }
}

variable "path" {
  description = "Full path of the resource"
  type        = string

  validation {
    condition     = length(var.path) > 0
    error_message = "data_aws_api_gateway_resource, path must be a non-empty string."
  }
}