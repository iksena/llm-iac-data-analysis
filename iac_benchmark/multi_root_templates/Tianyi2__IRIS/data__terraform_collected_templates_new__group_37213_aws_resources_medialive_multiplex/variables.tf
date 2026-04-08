variable "availability_zones" {
  description = "A list of availability zones. You must specify exactly two."
  type        = list(string)
  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "resource_aws_medialive_multiplex, availability_zones must contain exactly two availability zones."
  }
}

variable "multiplex_settings" {
  description = "Multiplex settings configuration"
  type = object({
    transport_stream_bitrate                = number
    transport_stream_id                     = number
    transport_stream_reserved_bitrate       = optional(number)
    maximum_video_buffer_delay_milliseconds = optional(number)
  })
  validation {
    condition     = var.multiplex_settings.transport_stream_bitrate > 0
    error_message = "resource_aws_medialive_multiplex, transport_stream_bitrate must be greater than 0."
  }
  validation {
    condition     = var.multiplex_settings.transport_stream_id > 0
    error_message = "resource_aws_medialive_multiplex, transport_stream_id must be greater than 0."
  }
  validation {
    condition     = var.multiplex_settings.transport_stream_reserved_bitrate == null || var.multiplex_settings.transport_stream_reserved_bitrate >= 0
    error_message = "resource_aws_medialive_multiplex, transport_stream_reserved_bitrate must be greater than or equal to 0 when specified."
  }
  validation {
    condition     = var.multiplex_settings.maximum_video_buffer_delay_milliseconds == null || var.multiplex_settings.maximum_video_buffer_delay_milliseconds >= 0
    error_message = "resource_aws_medialive_multiplex, maximum_video_buffer_delay_milliseconds must be greater than or equal to 0 when specified."
  }
}

variable "name" {
  description = "Name of Multiplex"
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_medialive_multiplex, name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "start_multiplex" {
  description = "Whether to start the Multiplex"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the Multiplex"
  type        = map(string)
  default     = {}
}