variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "String identifier of the associated REST API."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id))
    error_message = "resource_aws_api_gateway_gateway_response, rest_api_id must be a valid API Gateway REST API ID containing only lowercase letters and numbers."
  }
}

variable "response_type" {
  description = "Response type of the associated GatewayResponse."
  type        = string

  validation {
    condition = contains([
      "DEFAULT_4XX", "DEFAULT_5XX", "ACCESS_DENIED", "API_CONFIGURATION_ERROR",
      "AUTHORIZER_CONFIGURATION_ERROR", "AUTHORIZER_FAILURE", "BAD_REQUEST_PARAMETERS",
      "BAD_REQUEST_BODY", "EXPIRED_TOKEN", "INTEGRATION_FAILURE", "INTEGRATION_TIMEOUT",
      "INVALID_API_KEY", "INVALID_SIGNATURE", "MISSING_AUTHENTICATION_TOKEN", "QUOTA_EXCEEDED",
      "REQUEST_TOO_LARGE", "RESOURCE_NOT_FOUND", "THROTTLED", "UNAUTHORIZED",
      "UNSUPPORTED_MEDIA_TYPE", "WAF_FILTERED"
    ], var.response_type)
    error_message = "resource_aws_api_gateway_gateway_response, response_type must be one of: DEFAULT_4XX, DEFAULT_5XX, ACCESS_DENIED, API_CONFIGURATION_ERROR, AUTHORIZER_CONFIGURATION_ERROR, AUTHORIZER_FAILURE, BAD_REQUEST_PARAMETERS, BAD_REQUEST_BODY, EXPIRED_TOKEN, INTEGRATION_FAILURE, INTEGRATION_TIMEOUT, INVALID_API_KEY, INVALID_SIGNATURE, MISSING_AUTHENTICATION_TOKEN, QUOTA_EXCEEDED, REQUEST_TOO_LARGE, RESOURCE_NOT_FOUND, THROTTLED, UNAUTHORIZED, UNSUPPORTED_MEDIA_TYPE, WAF_FILTERED."
  }
}

variable "status_code" {
  description = "HTTP status code of the Gateway Response."
  type        = string
  default     = null

  validation {
    condition     = var.status_code == null || can(regex("^[1-5][0-9][0-9]$", var.status_code))
    error_message = "resource_aws_api_gateway_gateway_response, status_code must be a valid HTTP status code (100-599)."
  }
}

variable "response_templates" {
  description = "Map of templates used to transform the response body."
  type        = map(string)
  default     = null

  validation {
    condition = var.response_templates == null || alltrue([
      for k, v in var.response_templates : can(regex("^[a-zA-Z0-9\\-\\/\\+\\*]+$", k))
    ])
    error_message = "resource_aws_api_gateway_gateway_response, response_templates keys must be valid media types."
  }
}

variable "response_parameters" {
  description = "Map of parameters (paths, query strings and headers) of the Gateway Response."
  type        = map(string)
  default     = null

  validation {
    condition = var.response_parameters == null || alltrue([
      for k, v in var.response_parameters : can(regex("^gatewayresponse\\.(header|path|querystring)\\.", k))
    ])
    error_message = "resource_aws_api_gateway_gateway_response, response_parameters keys must start with 'gatewayresponse.header.', 'gatewayresponse.path.', or 'gatewayresponse.querystring.'."
  }
}