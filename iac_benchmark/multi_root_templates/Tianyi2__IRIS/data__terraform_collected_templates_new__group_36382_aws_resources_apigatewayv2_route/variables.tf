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
    error_message = "resource_aws_apigatewayv2_route, api_id must be a non-empty string."
  }
}

variable "route_key" {
  description = "Route key for the route. For HTTP APIs, the route key can be either $default, or a combination of an HTTP method and resource path, for example, GET /pets."
  type        = string

  validation {
    condition     = length(var.route_key) > 0
    error_message = "resource_aws_apigatewayv2_route, route_key must be a non-empty string."
  }
}

variable "api_key_required" {
  description = "Boolean whether an API key is required for the route. Defaults to false. Supported only for WebSocket APIs."
  type        = bool
  default     = false
}

variable "authorization_scopes" {
  description = "Authorization scopes supported by this route. The scopes are used with a JWT authorizer to authorize the method invocation."
  type        = list(string)
  default     = null
}

variable "authorization_type" {
  description = "Authorization type for the route. For WebSocket APIs, valid values are NONE for open access, AWS_IAM for using AWS IAM permissions, and CUSTOM for using a Lambda authorizer. For HTTP APIs, valid values are NONE for open access, JWT for using JSON Web Tokens, AWS_IAM for using AWS IAM permissions, and CUSTOM for using a Lambda authorizer. Defaults to NONE."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "AWS_IAM", "CUSTOM", "JWT"], var.authorization_type)
    error_message = "resource_aws_apigatewayv2_route, authorization_type must be one of: NONE, AWS_IAM, CUSTOM, JWT."
  }
}

variable "authorizer_id" {
  description = "Identifier of the aws_apigatewayv2_authorizer resource to be associated with this route."
  type        = string
  default     = null
}

variable "model_selection_expression" {
  description = "The model selection expression for the route. Supported only for WebSocket APIs."
  type        = string
  default     = null
}

variable "operation_name" {
  description = "Operation name for the route. Must be between 1 and 64 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.operation_name == null || (length(var.operation_name) >= 1 && length(var.operation_name) <= 64)
    error_message = "resource_aws_apigatewayv2_route, operation_name must be between 1 and 64 characters in length."
  }
}

variable "request_models" {
  description = "Request models for the route. Supported only for WebSocket APIs."
  type        = map(string)
  default     = null
}

variable "request_parameter" {
  description = "Request parameters for the route. Supported only for WebSocket APIs."
  type = list(object({
    request_parameter_key = string
    required              = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.request_parameter : length(param.request_parameter_key) > 0
    ])
    error_message = "resource_aws_apigatewayv2_route, request_parameter_key must be a non-empty string for all request parameters."
  }
}

variable "route_response_selection_expression" {
  description = "The route response selection expression for the route. Supported only for WebSocket APIs."
  type        = string
  default     = null
}

variable "target" {
  description = "Target for the route, of the form integrations/IntegrationID, where IntegrationID is the identifier of an aws_apigatewayv2_integration resource."
  type        = string
  default     = null
}