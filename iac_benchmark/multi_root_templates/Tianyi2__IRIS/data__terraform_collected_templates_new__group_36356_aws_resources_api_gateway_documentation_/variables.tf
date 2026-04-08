variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "doc_version" {
  description = "Version identifier of the API documentation snapshot."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.doc_version))
    error_message = "resource_aws_api_gateway_documentation_version, doc_version must be a valid version identifier containing only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "rest_api_id" {
  description = "ID of the associated Rest API"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id))
    error_message = "resource_aws_api_gateway_documentation_version, rest_api_id must be a valid API Gateway REST API ID containing only lowercase letters and numbers."
  }
}

variable "description" {
  description = "Description of the API documentation version."
  type        = string
  default     = null
}