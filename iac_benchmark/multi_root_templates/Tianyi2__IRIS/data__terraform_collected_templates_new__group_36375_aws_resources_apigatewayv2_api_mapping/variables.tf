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
    error_message = "resource_aws_apigatewayv2_api_mapping, api_id cannot be empty."
  }
}

variable "domain_name" {
  description = "Domain name. Use the aws_apigatewayv2_domain_name resource to configure a domain name."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_apigatewayv2_api_mapping, domain_name cannot be empty."
  }
}

variable "stage" {
  description = "API stage. Use the aws_apigatewayv2_stage resource to configure an API stage."
  type        = string

  validation {
    condition     = length(var.stage) > 0
    error_message = "resource_aws_apigatewayv2_api_mapping, stage cannot be empty."
  }
}

variable "api_mapping_key" {
  description = "The API mapping key. Refer to REST API, HTTP API or WebSocket API."
  type        = string
  default     = null
}