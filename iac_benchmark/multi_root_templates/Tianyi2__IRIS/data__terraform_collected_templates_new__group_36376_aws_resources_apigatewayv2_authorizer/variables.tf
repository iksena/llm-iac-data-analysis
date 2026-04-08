variable "api_id" {
  description = "API identifier"
  type        = string
}

variable "authorizer_type" {
  description = "Authorizer type. Valid values: JWT, REQUEST"
  type        = string
  validation {
    condition     = contains(["JWT", "REQUEST"], var.authorizer_type)
    error_message = "resource_aws_apigatewayv2_authorizer, authorizer_type must be either 'JWT' or 'REQUEST'."
  }
}

variable "name" {
  description = "Name of the authorizer. Must be between 1 and 128 characters in length"
  type        = string
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_apigatewayv2_authorizer, name must be between 1 and 128 characters in length."
  }
}

variable "authorizer_credentials_arn" {
  description = "Required credentials as an IAM role for API Gateway to invoke the authorizer. Supported only for REQUEST authorizers"
  type        = string
  default     = null
}

variable "authorizer_payload_format_version" {
  description = "Format of the payload sent to an HTTP API Lambda authorizer. Required for HTTP API Lambda authorizers. Valid values: 1.0, 2.0"
  type        = string
  default     = null
  validation {
    condition     = var.authorizer_payload_format_version == null || contains(["1.0", "2.0"], var.authorizer_payload_format_version)
    error_message = "resource_aws_apigatewayv2_authorizer, authorizer_payload_format_version must be either '1.0' or '2.0'."
  }
}

variable "authorizer_result_ttl_in_seconds" {
  description = "Time to live (TTL) for cached authorizer results, in seconds. If it equals 0, authorization caching is disabled. If it is greater than 0, API Gateway caches authorizer responses. The maximum value is 3600, or 1 hour. Defaults to 300. Supported only for HTTP API Lambda authorizers"
  type        = number
  default     = 300
  validation {
    condition     = var.authorizer_result_ttl_in_seconds >= 0 && var.authorizer_result_ttl_in_seconds <= 3600
    error_message = "resource_aws_apigatewayv2_authorizer, authorizer_result_ttl_in_seconds must be between 0 and 3600."
  }
}

variable "authorizer_uri" {
  description = "Authorizer's Uniform Resource Identifier (URI). For REQUEST authorizers this must be a well-formed Lambda function URI. Supported only for REQUEST authorizers. Must be between 1 and 2048 characters in length"
  type        = string
  default     = null
  validation {
    condition = var.authorizer_uri == null || (
      length(var.authorizer_uri) >= 1 && length(var.authorizer_uri) <= 2048
    )
    error_message = "resource_aws_apigatewayv2_authorizer, authorizer_uri must be between 1 and 2048 characters in length."
  }
}

variable "enable_simple_responses" {
  description = "Whether a Lambda authorizer returns a response in a simple format. If enabled, the Lambda authorizer can return a boolean value instead of an IAM policy. Supported only for HTTP APIs"
  type        = bool
  default     = null
}

variable "identity_sources" {
  description = "Identity sources for which authorization is requested. For REQUEST authorizers the value is a list of one or more mapping expressions of the specified request parameters. For JWT authorizers the single entry specifies where to extract the JSON Web Token (JWT) from inbound requests"
  type        = list(string)
  default     = null
}

variable "jwt_configuration" {
  description = "Configuration of a JWT authorizer. Required for the JWT authorizer type. Supported only for HTTP APIs"
  type = object({
    audience = optional(list(string))
    issuer   = optional(string)
  })
  default = null
}