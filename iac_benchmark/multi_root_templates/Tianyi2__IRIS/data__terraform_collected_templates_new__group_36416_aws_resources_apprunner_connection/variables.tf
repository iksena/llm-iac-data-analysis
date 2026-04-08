variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "connection_name" {
  description = "Name of the connection"
  type        = string

  validation {
    condition     = length(var.connection_name) > 0
    error_message = "resource_aws_apprunner_connection, connection_name must not be empty."
  }
}

variable "provider_type" {
  description = "Source repository provider"
  type        = string

  validation {
    condition     = contains(["GITHUB"], var.provider_type)
    error_message = "resource_aws_apprunner_connection, provider_type must be one of: GITHUB."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}