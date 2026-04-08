variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "ID of the associated REST API"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id))
    error_message = "resource_aws_api_gateway_method, rest_api_id must be a valid REST API ID containing only lowercase alphanumeric characters."
  }
}

variable "resource_id" {
  description = "API resource ID"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_id))
    error_message = "resource_aws_api_gateway_method, resource_id must be a valid resource ID containing only lowercase alphanumeric characters."
  }
}

variable "http_method" {
  description = "HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = string

  validation {
    condition     = contains(["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "ANY"], var.http_method)
    error_message = "resource_aws_api_gateway_method, http_method must be one of: GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY."
  }
}

variable "authorization" {
  description = "Type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)"
  type        = string

  validation {
    condition     = contains(["NONE", "CUSTOM", "AWS_IAM", "COGNITO_USER_POOLS"], var.authorization)
    error_message = "resource_aws_api_gateway_method, authorization must be one of: NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS."
  }
}

variable "authorizer_id" {
  description = "Authorizer id to be used when the authorization is CUSTOM or COGNITO_USER_POOLS"
  type        = string
  default     = null

  validation {
    condition     = var.authorizer_id == null || can(regex("^[a-z0-9]+$", var.authorizer_id))
    error_message = "resource_aws_api_gateway_method, authorizer_id must be a valid authorizer ID containing only lowercase alphanumeric characters when provided."
  }
}

variable "authorization_scopes" {
  description = "Authorization scopes used when the authorization is COGNITO_USER_POOLS"
  type        = list(string)
  default     = null

  validation {
    condition = var.authorization_scopes == null || (
      length(var.authorization_scopes) > 0 &&
      alltrue([for scope in var.authorization_scopes : can(regex("^[a-zA-Z0-9:/_.-]+$", scope))])
    )
    error_message = "resource_aws_api_gateway_method, authorization_scopes must be a non-empty list of valid scope strings when provided."
  }
}

variable "api_key_required" {
  description = "Specify if the method requires an API key"
  type        = bool
  default     = null
}

variable "operation_name" {
  description = "Function name that will be given to the method when generating an SDK through API Gateway"
  type        = string
  default     = null

  validation {
    condition     = var.operation_name == null || can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.operation_name))
    error_message = "resource_aws_api_gateway_method, operation_name must be a valid function name starting with a letter and containing only alphanumeric characters and underscores when provided."
  }
}

variable "request_models" {
  description = "Map of the API models used for the request's content type"
  type        = map(string)
  default     = null

  validation {
    condition = var.request_models == null || alltrue([
      for content_type, model in var.request_models : can(regex("^[a-zA-Z0-9+/.-]+$", content_type))
    ])
    error_message = "resource_aws_api_gateway_method, request_models keys must be valid content types when provided."
  }
}

variable "request_validator_id" {
  description = "ID of a aws_api_gateway_request_validator"
  type        = string
  default     = null

  validation {
    condition     = var.request_validator_id == null || can(regex("^[a-z0-9]+$", var.request_validator_id))
    error_message = "resource_aws_api_gateway_method, request_validator_id must be a valid request validator ID containing only lowercase alphanumeric characters when provided."
  }
}

variable "request_parameters" {
  description = "Map of request parameters (from the path, query string and headers) that should be passed to the integration"
  type        = map(bool)
  default     = null

  validation {
    condition = var.request_parameters == null || alltrue([
      for param_name, required in var.request_parameters : can(regex("^method\\.request\\.(header|querystring|path)\\.[a-zA-Z0-9._-]+$", param_name))
    ])
    error_message = "resource_aws_api_gateway_method, request_parameters keys must follow the format 'method.request.(header|querystring|path).parameter-name' when provided."
  }
}