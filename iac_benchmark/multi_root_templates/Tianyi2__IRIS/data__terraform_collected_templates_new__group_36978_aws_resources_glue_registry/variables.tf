variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "registry_name" {
  description = "The Name of the registry."
  type        = string

  validation {
    condition     = length(var.registry_name) > 0
    error_message = "resource_aws_glue_registry, registry_name must not be empty."
  }
}

variable "description" {
  description = "A description of the registry."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}