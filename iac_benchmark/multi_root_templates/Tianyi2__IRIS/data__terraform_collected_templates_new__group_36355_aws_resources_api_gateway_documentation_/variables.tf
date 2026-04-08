variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "location_type" {
  description = "Type of API entity to which the documentation content applies. E.g., API, METHOD or REQUEST_BODY"
  type        = string

  validation {
    condition = contains([
      "API", "AUTHORIZER", "MODEL", "RESOURCE", "METHOD", "PATH_PARAMETER",
      "QUERY_PARAMETER", "REQUEST_HEADER", "REQUEST_BODY", "RESPONSE",
      "RESPONSE_HEADER", "RESPONSE_BODY"
    ], var.location_type)
    error_message = "resource_aws_api_gateway_documentation_part, location_type must be one of: API, AUTHORIZER, MODEL, RESOURCE, METHOD, PATH_PARAMETER, QUERY_PARAMETER, REQUEST_HEADER, REQUEST_BODY, RESPONSE, RESPONSE_HEADER, RESPONSE_BODY."
  }
}

variable "location_method" {
  description = "HTTP verb of a method. The default value is * for any method."
  type        = string
  default     = null

  validation {
    condition = var.location_method == null || contains([
      "*", "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "PATCH"
    ], var.location_method)
    error_message = "resource_aws_api_gateway_documentation_part, location_method must be one of: *, GET, POST, PUT, DELETE, HEAD, OPTIONS, PATCH."
  }
}

variable "location_name" {
  description = "Name of the targeted API entity."
  type        = string
  default     = null

  validation {
    condition     = var.location_name == null || length(var.location_name) > 0
    error_message = "resource_aws_api_gateway_documentation_part, location_name must not be empty when specified."
  }
}

variable "location_path" {
  description = "URL path of the target. The default value is / for the root resource."
  type        = string
  default     = null

  validation {
    condition     = var.location_path == null || can(regex("^/", var.location_path))
    error_message = "resource_aws_api_gateway_documentation_part, location_path must start with / when specified."
  }
}

variable "location_status_code" {
  description = "HTTP status code of a response. The default value is * for any status code."
  type        = string
  default     = null

  validation {
    condition     = var.location_status_code == null || can(regex("^(\\*|[1-5][0-9][0-9])$", var.location_status_code))
    error_message = "resource_aws_api_gateway_documentation_part, location_status_code must be * or a valid HTTP status code (100-599)."
  }
}

variable "properties" {
  description = "Content map of API-specific key-value pairs describing the targeted API entity. The map must be encoded as a JSON string."
  type        = string

  validation {
    condition     = can(jsondecode(var.properties))
    error_message = "resource_aws_api_gateway_documentation_part, properties must be a valid JSON string."
  }
}

variable "rest_api_id" {
  description = "ID of the associated Rest API"
  type        = string

  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "resource_aws_api_gateway_documentation_part, rest_api_id must not be empty."
  }
}