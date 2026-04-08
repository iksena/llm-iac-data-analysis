variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authorizer_uri" {
  description = "Authorizer's Uniform Resource Identifier (URI). This must be a well-formed Lambda function URI. Required for type TOKEN/REQUEST."
  type        = string
  default     = null

  validation {
    condition     = var.authorizer_uri == null || can(regex("^arn:aws:apigateway:[^:]+:lambda:path/", var.authorizer_uri))
    error_message = "resource_aws_api_gateway_authorizer, authorizer_uri must be a well-formed Lambda function URI in the form of arn:aws:apigateway:{region}:lambda:path/{service_api}"
  }
}

variable "name" {
  description = "Name of the authorizer"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_api_gateway_authorizer, name must not be empty"
  }
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_authorizer, rest_api_id must not be empty"
  }
}

variable "identity_source" {
  description = "Source of the identity in an incoming request. Defaults to method.request.header.Authorization. For REQUEST type, this may be a comma-separated list of values."
  type        = string
  default     = "method.request.header.Authorization"
}

variable "type" {
  description = "Type of the authorizer. Possible values are TOKEN for a Lambda function using a single authorization token, REQUEST for a Lambda function using incoming request parameters, or COGNITO_USER_POOLS for using an Amazon Cognito user pool."
  type        = string
  default     = "TOKEN"

  validation {
    condition     = contains(["TOKEN", "REQUEST", "COGNITO_USER_POOLS"], var.type)
    error_message = "resource_aws_api_gateway_authorizer, type must be one of: TOKEN, REQUEST, COGNITO_USER_POOLS"
  }
}

variable "authorizer_credentials" {
  description = "Credentials required for the authorizer. To specify an IAM Role for API Gateway to assume, use the IAM Role ARN."
  type        = string
  default     = null
}

variable "authorizer_result_ttl_in_seconds" {
  description = "TTL of cached authorizer results in seconds. Defaults to 300."
  type        = number
  default     = 300

  validation {
    condition     = var.authorizer_result_ttl_in_seconds >= 0 && var.authorizer_result_ttl_in_seconds <= 3600
    error_message = "resource_aws_api_gateway_authorizer, authorizer_result_ttl_in_seconds must be between 0 and 3600 seconds"
  }
}

variable "identity_validation_expression" {
  description = "Validation expression for the incoming identity. For TOKEN type, this value should be a regular expression."
  type        = string
  default     = null
}

variable "provider_arns" {
  description = "List of the Amazon Cognito user pool ARNs. Required for type COGNITO_USER_POOLS. Each element should be in format: arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}"
  type        = list(string)
  default     = null

  validation {
    condition = var.provider_arns == null || alltrue([
      for arn in var.provider_arns : can(regex("^arn:aws:cognito-idp:[^:]+:[^:]+:userpool/", arn))
    ])
    error_message = "resource_aws_api_gateway_authorizer, provider_arns must contain valid Cognito user pool ARNs in format: arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}"
  }
}