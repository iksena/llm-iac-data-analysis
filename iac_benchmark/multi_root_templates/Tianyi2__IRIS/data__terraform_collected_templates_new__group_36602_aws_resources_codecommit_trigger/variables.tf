variable "repository_name" {
  description = "The name for the repository. This needs to be less than 100 characters."
  type        = string

  validation {
    condition     = length(var.repository_name) < 100
    error_message = "resource_aws_codecommit_trigger, repository_name must be less than 100 characters."
  }

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "resource_aws_codecommit_trigger, repository_name cannot be empty."
  }
}

variable "trigger" {
  description = "Configuration block for the trigger"
  type = list(object({
    name            = string
    destination_arn = string
    events          = list(string)
    custom_data     = optional(string)
    branches        = optional(list(string))
  }))

  validation {
    condition     = length(var.trigger) > 0
    error_message = "resource_aws_codecommit_trigger, trigger must contain at least one trigger configuration."
  }

  validation {
    condition = alltrue([
      for trigger in var.trigger : trigger.name != null && length(trigger.name) > 0
    ])
    error_message = "resource_aws_codecommit_trigger, trigger name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for trigger in var.trigger : trigger.destination_arn != null && length(trigger.destination_arn) > 0
    ])
    error_message = "resource_aws_codecommit_trigger, trigger destination_arn is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for trigger in var.trigger : trigger.events != null && length(trigger.events) > 0
    ])
    error_message = "resource_aws_codecommit_trigger, trigger events is required and must contain at least one event."
  }

  validation {
    condition = alltrue([
      for trigger in var.trigger : alltrue([
        for event in trigger.events : contains(["all", "updateReference", "createReference", "deleteReference"], event)
      ])
    ])
    error_message = "resource_aws_codecommit_trigger, trigger events must be one of: all, updateReference, createReference, deleteReference."
  }
}