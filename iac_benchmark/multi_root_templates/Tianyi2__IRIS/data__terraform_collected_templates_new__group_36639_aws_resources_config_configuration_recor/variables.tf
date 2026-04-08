variable "name" {
  description = "The name of the recorder. Defaults to default. Changing it recreates the resource."
  type        = string
  default     = "default"
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM role. Used to make read or write requests to the delivery channel and to describe the AWS resources associated with the account."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_config_configuration_recorder, role_arn must be a valid IAM role ARN starting with 'arn:aws:iam::'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "recording_group" {
  description = "Recording group configuration"
  type = object({
    all_supported                 = optional(bool, true)
    include_global_resource_types = optional(bool)
    resource_types                = optional(list(string))
    exclusion_by_resource_types = optional(object({
      resource_types = optional(list(string))
    }))
    recording_strategy = optional(object({
      use_only = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.recording_group == null || (
      var.recording_group.all_supported == false || var.recording_group.resource_types == null
    )
    error_message = "resource_aws_config_configuration_recorder, recording_group: all_supported conflicts with resource_types."
  }

  validation {
    condition = var.recording_group == null || (
      var.recording_group.all_supported == false || var.recording_group.exclusion_by_resource_types == null
    )
    error_message = "resource_aws_config_configuration_recorder, recording_group: exclusion_by_resource_types requires all_supported = false."
  }

  validation {
    condition = var.recording_group == null || (
      var.recording_group.all_supported == true || var.recording_group.include_global_resource_types == null
    )
    error_message = "resource_aws_config_configuration_recorder, recording_group: include_global_resource_types requires all_supported = true."
  }

  validation {
    condition = var.recording_group == null || var.recording_group.recording_strategy == null || (
      var.recording_group.recording_strategy.use_only == null ||
      contains(["EXCLUSION_BY_RESOURCE_TYPES", "INCLUSION_BY_RESOURCE_TYPES", "ALL"], var.recording_group.recording_strategy.use_only)
    )
    error_message = "resource_aws_config_configuration_recorder, recording_group.recording_strategy.use_only must be one of: EXCLUSION_BY_RESOURCE_TYPES, INCLUSION_BY_RESOURCE_TYPES, ALL."
  }
}

variable "recording_mode" {
  description = "Recording mode configuration"
  type = object({
    recording_frequency = string
    recording_mode_overrides = optional(list(object({
      description         = optional(string)
      resource_types      = list(string)
      recording_frequency = string
    })))
  })
  default = null

  validation {
    condition     = var.recording_mode == null || contains(["CONTINUOUS", "DAILY"], var.recording_mode.recording_frequency)
    error_message = "resource_aws_config_configuration_recorder, recording_mode.recording_frequency must be either 'CONTINUOUS' or 'DAILY'."
  }

  validation {
    condition = var.recording_mode == null || var.recording_mode.recording_mode_overrides == null || alltrue([
      for override in var.recording_mode.recording_mode_overrides :
      contains(["CONTINUOUS", "DAILY"], override.recording_frequency)
    ])
    error_message = "resource_aws_config_configuration_recorder, recording_mode.recording_mode_overrides: recording_frequency must be either 'CONTINUOUS' or 'DAILY'."
  }

  validation {
    condition = var.recording_mode == null || var.recording_mode.recording_mode_overrides == null || alltrue([
      for override in var.recording_mode.recording_mode_overrides :
      length(override.resource_types) > 0
    ])
    error_message = "resource_aws_config_configuration_recorder, recording_mode.recording_mode_overrides: resource_types must contain at least one resource type."
  }
}