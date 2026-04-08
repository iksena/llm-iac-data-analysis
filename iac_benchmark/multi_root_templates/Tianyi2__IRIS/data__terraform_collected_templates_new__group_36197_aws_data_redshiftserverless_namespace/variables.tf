variable "namespace_name" {
  description = "The name of the namespace."
  type        = string

  validation {
    condition     = length(var.namespace_name) > 0
    error_message = "data_aws_redshiftserverless_namespace, namespace_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}