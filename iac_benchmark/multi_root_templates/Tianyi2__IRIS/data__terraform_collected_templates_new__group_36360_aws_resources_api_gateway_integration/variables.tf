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
    error_message = "resource_aws_api_gateway_integration, rest_api_id must be a valid API Gateway REST API ID."
  }
}

variable "resource_id" {
  description = "API resource ID"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_id))
    error_message = "resource_aws_api_gateway_integration, resource_id must be a valid API Gateway resource ID."
  }
}

variable "http_method" {
  description = "HTTP method when calling the associated resource"
  type        = string

  validation {
    condition     = contains(["GET", "POST", "PUT", "DELETE", "HEAD", "OPTION", "ANY"], var.http_method)
    error_message = "resource_aws_api_gateway_integration, http_method must be one of: GET, POST, PUT, DELETE, HEAD, OPTION, ANY."
  }
}

variable "integration_http_method" {
  description = "Integration HTTP method specifying how API Gateway will interact with the back end"
  type        = string
  default     = null

  validation {
    condition     = var.integration_http_method == null || contains(["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONs", "ANY", "PATCH"], var.integration_http_method)
    error_message = "resource_aws_api_gateway_integration, integration_http_method must be one of: GET, POST, PUT, DELETE, HEAD, OPTIONs, ANY, PATCH."
  }
}

variable "type" {
  description = "Integration input's type"
  type        = string

  validation {
    condition     = contains(["HTTP", "MOCK", "AWS", "AWS_PROXY", "HTTP_PROXY"], var.type)
    error_message = "resource_aws_api_gateway_integration, type must be one of: HTTP, MOCK, AWS, AWS_PROXY, HTTP_PROXY."
  }
}

variable "connection_type" {
  description = "Integration input's connectionType"
  type        = string
  default     = "INTERNET"

  validation {
    condition     = contains(["INTERNET", "VPC_LINK"], var.connection_type)
    error_message = "resource_aws_api_gateway_integration, connection_type must be one of: INTERNET, VPC_LINK."
  }
}

variable "connection_id" {
  description = "ID of the VpcLink used for the integration"
  type        = string
  default     = null
}

variable "uri" {
  description = "Input's URI"
  type        = string
  default     = null
}

variable "credentials" {
  description = "Credentials required for the integration"
  type        = string
  default     = null
}

variable "request_templates" {
  description = "Map of the integration's request templates"
  type        = map(string)
  default     = {}
}

variable "request_parameters" {
  description = "Map of request query string parameters and headers that should be passed to the backend responder"
  type        = map(string)
  default     = {}
}

variable "passthrough_behavior" {
  description = "Integration passthrough behavior"
  type        = string
  default     = null

  validation {
    condition     = var.passthrough_behavior == null || contains(["WHEN_NO_MATCH", "WHEN_NO_TEMPLATES", "NEVER"], var.passthrough_behavior)
    error_message = "resource_aws_api_gateway_integration, passthrough_behavior must be one of: WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER."
  }
}

variable "cache_key_parameters" {
  description = "List of cache key parameters for the integration"
  type        = list(string)
  default     = []
}

variable "cache_namespace" {
  description = "Integration's cache namespace"
  type        = string
  default     = null
}

variable "content_handling" {
  description = "How to handle request payload content type conversions"
  type        = string
  default     = null

  validation {
    condition     = var.content_handling == null || contains(["CONVERT_TO_BINARY", "CONVERT_TO_TEXT"], var.content_handling)
    error_message = "resource_aws_api_gateway_integration, content_handling must be one of: CONVERT_TO_BINARY, CONVERT_TO_TEXT."
  }
}

variable "timeout_milliseconds" {
  description = "Custom timeout between 50 and 300,000 milliseconds"
  type        = number
  default     = 29000

  validation {
    condition     = var.timeout_milliseconds >= 50 && var.timeout_milliseconds <= 300000
    error_message = "resource_aws_api_gateway_integration, timeout_milliseconds must be between 50 and 300,000 milliseconds."
  }
}

variable "tls_config" {
  description = "TLS configuration"
  type = object({
    insecure_skip_verification = optional(bool, false)
  })
  default = null
}