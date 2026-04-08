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
    error_message = "resource_aws_api_gateway_resource, rest_api_id must be a non-empty string."
  }
}

variable "parent_id" {
  description = "ID of the parent API resource"
  type        = string

  validation {
    condition     = length(var.parent_id) > 0
    error_message = "resource_aws_api_gateway_resource, parent_id must be a non-empty string."
  }
}

variable "path_part" {
  description = "Last path segment of this API resource."
  type        = string

  validation {
    condition     = length(var.path_part) > 0
    error_message = "resource_aws_api_gateway_resource, path_part must be a non-empty string."
  }
}