variable "name" {
  description = "Name of the REST API to look up. If no REST API is found with this name, an error will be returned. If multiple REST APIs are found with this name, an error will be returned."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_api_gateway_rest_api, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_api_gateway_rest_api, region must be a valid AWS region format."
  }
}