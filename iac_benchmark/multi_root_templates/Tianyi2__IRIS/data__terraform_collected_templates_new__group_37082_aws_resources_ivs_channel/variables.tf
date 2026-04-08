variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authorized" {
  description = "If true, channel is private (enabled for playback authorization)."
  type        = bool
  default     = null
}

variable "latency_mode" {
  description = "Channel latency mode. Valid values: NORMAL, LOW."
  type        = string
  default     = null

  validation {
    condition     = var.latency_mode == null || contains(["NORMAL", "LOW"], var.latency_mode)
    error_message = "resource_aws_ivs_channel, latency_mode must be one of: NORMAL, LOW."
  }
}

variable "name" {
  description = "Channel name."
  type        = string
  default     = null
}

variable "recording_configuration_arn" {
  description = "Recording configuration ARN."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Channel type, which determines the allowable resolution and bitrate. Valid values: STANDARD, BASIC."
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["STANDARD", "BASIC"], var.type)
    error_message = "resource_aws_ivs_channel, type must be one of: STANDARD, BASIC."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = null
}