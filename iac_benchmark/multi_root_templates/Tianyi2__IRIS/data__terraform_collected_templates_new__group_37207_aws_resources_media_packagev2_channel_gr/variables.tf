variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A unique identifier naming the channel group"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_media_packagev2_channel_group, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "description" {
  description = "A description of the channel group"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}