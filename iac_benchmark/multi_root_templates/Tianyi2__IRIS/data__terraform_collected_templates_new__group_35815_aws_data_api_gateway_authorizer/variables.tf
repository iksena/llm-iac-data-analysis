variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authorizer_id" {
  description = "Authorizer identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.authorizer_id))
    error_message = "data_aws_api_gateway_authorizer, authorizer_id must be a valid authorizer identifier."
  }
}

variable "rest_api_id" {
  description = "ID of the associated REST API."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.rest_api_id))
    error_message = "data_aws_api_gateway_authorizer, rest_api_id must be a valid REST API identifier."
  }
}