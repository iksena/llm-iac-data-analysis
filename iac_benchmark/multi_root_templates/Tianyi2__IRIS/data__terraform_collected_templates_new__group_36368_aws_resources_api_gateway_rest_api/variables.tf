variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "api_key_source" {
  description = "Source of the API key for requests"
  type        = string
  default     = null
  validation {
    condition     = var.api_key_source == null || contains(["HEADER", "AUTHORIZER"], var.api_key_source)
    error_message = "resource_aws_api_gateway_rest_api, api_key_source must be either 'HEADER' or 'AUTHORIZER'."
  }
}

variable "binary_media_types" {
  description = "List of binary media types supported by the REST API"
  type        = list(string)
  default     = null
}

variable "body" {
  description = "OpenAPI specification that defines the set of routes and integrations"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the REST API"
  type        = string
  default     = null
}

variable "disable_execute_api_endpoint" {
  description = "Whether clients can invoke your API by using the default execute-api endpoint"
  type        = bool
  default     = false
}

variable "endpoint_configuration" {
  description = "Configuration block defining API endpoint configuration"
  type = object({
    ip_address_type  = optional(string)
    types            = list(string)
    vpc_endpoint_ids = optional(set(string))
  })
  default = null

  validation {
    condition = var.endpoint_configuration == null || (
      var.endpoint_configuration.ip_address_type == null ||
      contains(["ipv4", "dualstack"], var.endpoint_configuration.ip_address_type)
    )
    error_message = "resource_aws_api_gateway_rest_api, endpoint_configuration.ip_address_type must be either 'ipv4' or 'dualstack'."
  }

  validation {
    condition = var.endpoint_configuration == null || (
      length(var.endpoint_configuration.types) > 0 &&
      alltrue([for type in var.endpoint_configuration.types : contains(["EDGE", "REGIONAL", "PRIVATE"], type)])
    )
    error_message = "resource_aws_api_gateway_rest_api, endpoint_configuration.types must contain only 'EDGE', 'REGIONAL', or 'PRIVATE' values."
  }
}

variable "minimum_compression_size" {
  description = "Minimum response size to compress for the REST API"
  type        = string
  default     = null
  validation {
    condition = var.minimum_compression_size == null || (
      can(tonumber(var.minimum_compression_size)) &&
      tonumber(var.minimum_compression_size) >= -1 &&
      tonumber(var.minimum_compression_size) <= 10485760
    )
    error_message = "resource_aws_api_gateway_rest_api, minimum_compression_size must be a string containing an integer value between -1 and 10485760."
  }
}

variable "name" {
  description = "Name of the REST API"
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_api_gateway_rest_api, name cannot be empty."
  }
}

variable "fail_on_warnings" {
  description = "Whether warnings while API Gateway is creating or updating the resource should return an error"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Map of customizations for importing the specification in the body argument"
  type        = map(string)
  default     = null
}

variable "policy" {
  description = "JSON formatted policy document that controls access to the API Gateway"
  type        = string
  default     = null
}

variable "put_rest_api_mode" {
  description = "Mode of the PutRestApi operation when importing an OpenAPI specification"
  type        = string
  default     = null
  validation {
    condition     = var.put_rest_api_mode == null || contains(["merge", "overwrite"], var.put_rest_api_mode)
    error_message = "resource_aws_api_gateway_rest_api, put_rest_api_mode must be either 'merge' or 'overwrite'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = null
}