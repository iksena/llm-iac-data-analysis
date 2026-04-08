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
    error_message = "resource_aws_apigatewayv2_route_response, api_id must be a non-empty string."
  }
}

variable "route_id" {
  description = "Identifier of the aws_apigatewayv2_route."
  type        = string

  validation {
    condition     = length(var.route_id) > 0
    error_message = "resource_aws_apigatewayv2_route_response, route_id must be a non-empty string."
  }
}

variable "route_response_key" {
  description = "Route response key."
  type        = string

  validation {
    condition     = length(var.route_response_key) > 0
    error_message = "resource_aws_apigatewayv2_route_response, route_response_key must be a non-empty string."
  }
}

variable "model_selection_expression" {
  description = "The model selection expression for the route response."
  type        = string
  default     = null
}

variable "response_models" {
  description = "Response models for the route response."
  type        = map(string)
  default     = null
}