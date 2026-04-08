variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the API. Must be less than or equal to 128 characters in length."
  type        = string

  validation {
    condition     = length(var.name) <= 128
    error_message = "resource_aws_apigatewayv2_api, name must be less than or equal to 128 characters in length."
  }
}

variable "protocol_type" {
  description = "API protocol. Valid values: HTTP, WEBSOCKET."
  type        = string

  validation {
    condition     = contains(["HTTP", "WEBSOCKET"], var.protocol_type)
    error_message = "resource_aws_apigatewayv2_api, protocol_type must be either HTTP or WEBSOCKET."
  }
}

variable "api_key_selection_expression" {
  description = "An API key selection expression. Valid values: $context.authorizer.usageIdentifierKey, $request.header.x-api-key. Defaults to $request.header.x-api-key. Applicable for WebSocket APIs."
  type        = string
  default     = "$request.header.x-api-key"

  validation {
    condition = contains([
      "$context.authorizer.usageIdentifierKey",
      "$request.header.x-api-key"
    ], var.api_key_selection_expression)
    error_message = "resource_aws_apigatewayv2_api, api_key_selection_expression must be either $context.authorizer.usageIdentifierKey or $request.header.x-api-key."
  }
}

variable "cors_configuration" {
  description = "Cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs."
  type = object({
    allow_credentials = optional(bool)
    allow_headers     = optional(set(string))
    allow_methods     = optional(set(string))
    allow_origins     = optional(set(string))
    expose_headers    = optional(set(string))
    max_age           = optional(number)
  })
  default = null
}

variable "credentials_arn" {
  description = "Part of quick create. Specifies any credentials required for the integration. Applicable for HTTP APIs."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the API. Must be less than or equal to 1024 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_apigatewayv2_api, description must be less than or equal to 1024 characters in length."
  }
}

variable "disable_execute_api_endpoint" {
  description = "Whether clients can invoke the API by using the default execute-api endpoint. By default, clients can invoke the API with the default {api_id}.execute-api.{region}.amazonaws.com endpoint. To require that clients use a custom domain name to invoke the API, disable the default endpoint."
  type        = bool
  default     = null
}

variable "ip_address_type" {
  description = "The IP address types that can invoke the API. Valid values: ipv4, dualstack. Use ipv4 to allow only IPv4 addresses to invoke your API, or use dualstack to allow both IPv4 and IPv6 addresses to invoke your API. Defaults to ipv4."
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "dualstack"], var.ip_address_type)
    error_message = "resource_aws_apigatewayv2_api, ip_address_type must be either ipv4 or dualstack."
  }
}

variable "route_key" {
  description = "Part of quick create. Specifies any route key. Applicable for HTTP APIs."
  type        = string
  default     = null
}

variable "route_selection_expression" {
  description = "The route selection expression for the API. Defaults to $request.method $request.path."
  type        = string
  default     = "$request.method $request.path"
}

variable "tags" {
  description = "Map of tags to assign to the API. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "target" {
  description = "Part of quick create. Quick create produces an API with an integration, a default catch-all route, and a default stage which is configured to automatically deploy changes. For HTTP integrations, specify a fully qualified URL. For Lambda integrations, specify a function ARN. The type of the integration will be HTTP_PROXY or AWS_PROXY, respectively. Applicable for HTTP APIs."
  type        = string
  default     = null
}

variable "body" {
  description = "An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs."
  type        = string
  default     = null
}

variable "api_version" {
  description = "Version identifier for the API. Must be between 1 and 64 characters in length."
  type        = string
  default     = null

  validation {
    condition     = var.api_version == null || (length(var.api_version) >= 1 && length(var.api_version) <= 64)
    error_message = "resource_aws_apigatewayv2_api, version must be between 1 and 64 characters in length."
  }
}

variable "fail_on_warnings" {
  description = "Whether warnings should return an error while API Gateway is creating or updating the resource using an OpenAPI specification. Defaults to false. Applicable for HTTP APIs."
  type        = bool
  default     = false
}