variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the opt-out list."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_pinpointsmsvoicev2_opt_out_list, name must be a non-empty string containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}