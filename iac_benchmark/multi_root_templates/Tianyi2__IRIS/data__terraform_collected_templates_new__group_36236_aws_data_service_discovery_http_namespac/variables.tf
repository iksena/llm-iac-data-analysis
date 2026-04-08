variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_service_discovery_http_namespace, region must be a valid AWS region format or null."
  }
}

variable "name" {
  description = "Name of the http namespace."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) > 0
    error_message = "data_aws_service_discovery_http_namespace, name must be a non-empty string containing only alphanumeric characters, periods, underscores, and hyphens."
  }
}