variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_api_gateway_authorizers, region must be a valid AWS region identifier or null."
  }
}

variable "rest_api_id" {
  description = "ID of the associated REST API."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{10}$", var.rest_api_id))
    error_message = "data_aws_api_gateway_authorizers, rest_api_id must be a valid API Gateway REST API ID (10 character alphanumeric string)."
  }
}