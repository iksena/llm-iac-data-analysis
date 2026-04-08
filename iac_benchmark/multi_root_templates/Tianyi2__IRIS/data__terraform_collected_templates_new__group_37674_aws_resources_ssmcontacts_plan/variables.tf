variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "contact_id" {
  description = "The Amazon Resource Name (ARN) of the contact or escalation plan."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ssm-contacts:", var.contact_id))
    error_message = "resource_aws_ssmcontacts_plan, contact_id must be a valid SSM Contacts ARN starting with 'arn:aws:ssm-contacts:'."
  }
}

variable "stage" {
  description = "One or more configuration blocks for specifying a list of stages that the escalation plan or engagement plan uses to engage contacts and contact methods."
  type = list(object({
    duration_in_minutes = number
    target = list(object({
      channel_target_info = optional(object({
        contact_channel_id        = string
        retry_interval_in_minutes = optional(number)
      }))
      contact_target_info = optional(object({
        contact_id   = optional(string)
        is_essential = optional(bool)
      }))
    }))
  }))

  validation {
    condition     = length(var.stage) > 0
    error_message = "resource_aws_ssmcontacts_plan, stage must contain at least one stage configuration."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : stage.duration_in_minutes >= 0
    ])
    error_message = "resource_aws_ssmcontacts_plan, stage duration_in_minutes must be greater than or equal to 0."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : length(stage.target) > 0
    ])
    error_message = "resource_aws_ssmcontacts_plan, stage target must contain at least one target configuration."
  }

  validation {
    condition = alltrue(flatten([
      for stage in var.stage : [
        for target in stage.target : (
          (target.channel_target_info != null ? 1 : 0) +
          (target.contact_target_info != null ? 1 : 0)
        ) == 1
      ]
    ]))
    error_message = "resource_aws_ssmcontacts_plan, stage target must specify exactly one of channel_target_info or contact_target_info."
  }

  validation {
    condition = alltrue(flatten([
      for stage in var.stage : [
        for target in stage.target : [
          for channel_info in target.channel_target_info != null ? [target.channel_target_info] : [] :
          can(regex("^arn:aws:ssm-contacts:", channel_info.contact_channel_id))
        ]
      ]
    ]))
    error_message = "resource_aws_ssmcontacts_plan, stage target channel_target_info contact_channel_id must be a valid SSM Contacts ARN starting with 'arn:aws:ssm-contacts:'."
  }

  validation {
    condition = alltrue(flatten([
      for stage in var.stage : [
        for target in stage.target : [
          for channel_info in target.channel_target_info != null ? [target.channel_target_info] : [] :
          channel_info.retry_interval_in_minutes == null || channel_info.retry_interval_in_minutes >= 0
        ]
      ]
    ]))
    error_message = "resource_aws_ssmcontacts_plan, stage target channel_target_info retry_interval_in_minutes must be greater than or equal to 0 when specified."
  }

  validation {
    condition = alltrue(flatten([
      for stage in var.stage : [
        for target in stage.target : [
          for contact_info in target.contact_target_info != null ? [target.contact_target_info] : [] :
          contact_info.contact_id == null || can(regex("^arn:aws:ssm-contacts:", contact_info.contact_id))
        ]
      ]
    ]))
    error_message = "resource_aws_ssmcontacts_plan, stage target contact_target_info contact_id must be a valid SSM Contacts ARN starting with 'arn:aws:ssm-contacts:' when specified."
  }

  validation {
    condition = alltrue(flatten([
      for stage in var.stage : [
        for target in stage.target :
        stage.duration_in_minutes > 0 || length(target) > 0
      ]
    ]))
    error_message = "resource_aws_ssmcontacts_plan, stage duration_in_minutes can only be set to 0 if a target is specified."
  }
}