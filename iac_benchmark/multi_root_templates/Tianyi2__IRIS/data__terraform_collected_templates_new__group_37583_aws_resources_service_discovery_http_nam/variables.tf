variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the http namespace."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_service_discovery_http_namespace, name must not be empty."
  }
}

variable "description" {
  description = "The description that you specify for the namespace when you create it."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the namespace."
  type        = map(string)
  default     = {}
}