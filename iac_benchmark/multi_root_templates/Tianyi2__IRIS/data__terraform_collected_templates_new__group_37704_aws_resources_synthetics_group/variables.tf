variable "name" {
  description = "Name of the group"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_synthetics_group, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}