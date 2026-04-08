variable "multiplex_id" {
  description = "Multiplex ID"
  type        = string

  validation {
    condition     = length(var.multiplex_id) > 0
    error_message = "resource_aws_medialive_multiplex_program, multiplex_id cannot be empty."
  }
}

variable "program_name" {
  description = "Unique program name"
  type        = string

  validation {
    condition     = length(var.program_name) > 0
    error_message = "resource_aws_medialive_multiplex_program, program_name cannot be empty."
  }
}

variable "multiplex_program_settings" {
  description = "MultiplexProgram settings"
  type = object({
    program_number             = number
    preferred_channel_pipeline = string
    service_descriptor = optional(object({
      provider_name = string
      service_name  = string
    }))
    video_settings = optional(object({
      constant_bitrate = optional(number)
      statmux_settings = optional(object({
        minimum_bitrate = optional(number)
        maximum_bitrate = optional(number)
        priority        = optional(number)
      }))
    }))
  })

  validation {
    condition     = var.multiplex_program_settings.program_number > 0
    error_message = "resource_aws_medialive_multiplex_program, program_number must be greater than 0."
  }

  validation {
    condition     = contains(["CURRENTLY_ACTIVE", "PIPELINE_0", "PIPELINE_1"], var.multiplex_program_settings.preferred_channel_pipeline)
    error_message = "resource_aws_medialive_multiplex_program, preferred_channel_pipeline must be one of: CURRENTLY_ACTIVE, PIPELINE_0, PIPELINE_1."
  }

  validation {
    condition = var.multiplex_program_settings.service_descriptor == null || (
      length(var.multiplex_program_settings.service_descriptor.provider_name) > 0 &&
      length(var.multiplex_program_settings.service_descriptor.service_name) > 0
    )
    error_message = "resource_aws_medialive_multiplex_program, service_descriptor provider_name and service_name cannot be empty when service_descriptor is specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}