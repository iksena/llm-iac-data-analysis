variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "API identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.api_id))
    error_message = "resource_aws_apigatewayv2_integration_response, api_id must be a valid API identifier containing only lowercase alphanumeric characters."
  }
}

variable "integration_id" {
  description = "Identifier of the aws_apigatewayv2_integration."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.integration_id))
    error_message = "resource_aws_apigatewayv2_integration_response, integration_id must be a valid integration identifier containing only lowercase alphanumeric characters."
  }
}

variable "integration_response_key" {
  description = "Integration response key."
  type        = string

  validation {
    condition     = length(var.integration_response_key) > 0
    error_message = "resource_aws_apigatewayv2_integration_response, integration_response_key cannot be empty."
  }
}

variable "content_handling_strategy" {
  description = "How to handle response payload content type conversions. Valid values: CONVERT_TO_BINARY, CONVERT_TO_TEXT."
  type        = string
  default     = null

  validation {
    condition = var.content_handling_strategy == null || contains([
      "CONVERT_TO_BINARY",
      "CONVERT_TO_TEXT"
    ], var.content_handling_strategy)
    error_message = "resource_aws_apigatewayv2_integration_response, content_handling_strategy must be one of: CONVERT_TO_BINARY, CONVERT_TO_TEXT."
  }
}

variable "response_templates" {
  description = "Map of Velocity templates that are applied on the request payload based on the value of the Content-Type header sent by the client."
  type        = map(string)
  default     = null
}

variable "template_selection_expression" {
  description = "The template selection expression for the integration response."
  type        = string
  default     = null
}