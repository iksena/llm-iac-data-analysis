variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Specifies the description of the launch."
  type        = string
  default     = null
}

variable "groups" {
  description = "One or up to five blocks that contain the feature and variations that are to be used for the launch."
  type = list(object({
    description = optional(string)
    feature     = string
    name        = string
    variation   = string
  }))

  validation {
    condition     = length(var.groups) >= 1 && length(var.groups) <= 5
    error_message = "resource_aws_evidently_launch, groups must contain between 1 and 5 blocks."
  }
}

variable "metric_monitors" {
  description = "One or up to three blocks that define the metrics that will be used to monitor the launch performance."
  type = list(object({
    metric_definition = object({
      entity_id_key = string
      event_pattern = string
      name          = string
      unit_label    = optional(string)
      value_key     = string
    })
  }))
  default = []

  validation {
    condition     = length(var.metric_monitors) <= 3
    error_message = "resource_aws_evidently_launch, metric_monitors must contain up to 3 blocks."
  }
}

variable "name" {
  description = "The name for the new launch. Minimum length of 1. Maximum length of 127."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 127
    error_message = "resource_aws_evidently_launch, name must be between 1 and 127 characters."
  }
}

variable "project" {
  description = "The name or ARN of the project that is to contain the new launch."
  type        = string
}

variable "randomization_salt" {
  description = "When Evidently assigns a particular user session to a launch, it must use a randomization ID to determine which variation the user session is served. This randomization ID is a combination of the entity ID and randomizationSalt. If you omit randomizationSalt, Evidently uses the launch name as the randomizationSalt."
  type        = string
  default     = null
}

variable "scheduled_splits_config" {
  description = "A block that defines the traffic allocation percentages among the feature variations during each step of the launch."
  type = object({
    steps = list(object({
      group_weights = map(number)
      start_time    = string
      segment_overrides = optional(list(object({
        evaluation_order = number
        segment          = string
        weights          = map(number)
      })), [])
    }))
  })
  default = null

  validation {
    condition = var.scheduled_splits_config == null ? true : (
      length(var.scheduled_splits_config.steps) >= 1 && length(var.scheduled_splits_config.steps) <= 6
    )
    error_message = "resource_aws_evidently_launch, scheduled_splits_config steps must contain between 1 and 6 blocks."
  }

  validation {
    condition = var.scheduled_splits_config == null ? true : alltrue([
      for step in var.scheduled_splits_config.steps :
      length(step.segment_overrides) <= 6
    ])
    error_message = "resource_aws_evidently_launch, scheduled_splits_config segment_overrides must contain up to 6 blocks per step."
  }
}

variable "tags" {
  description = "Tags to apply to the launch. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "2m")
    delete = optional(string, "2m")
    update = optional(string, "2m")
  })
  default = {
    create = "2m"
    delete = "2m"
    update = "2m"
  }
}