variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "channel_id" {
  type        = string
  description = "A unique identifier describing the channel"

  validation {
    condition     = length(var.channel_id) > 0
    error_message = "resource_aws_media_package_channel, channel_id must not be empty."
  }
}

variable "description" {
  type        = string
  description = "A description of the channel"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}
}