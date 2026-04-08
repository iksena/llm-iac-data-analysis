variable "name" {
  description = "Name of the schedule. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "group_name" {
  description = "Name of the schedule group to associate with this schedule. When omitted, the default schedule group is used."
  type        = string
  default     = "default"
}

variable "description" {
  description = "Brief description of the schedule."
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "Defines when the schedule runs."
  type        = string

  validation {
    condition     = can(regex("^(rate\\(.*\\)|cron\\(.*\\)|at\\(.*\\))$", var.schedule_expression))
    error_message = "resource_aws_scheduler_schedule, schedule_expression must be a valid schedule expression (rate, cron, or at)."
  }
}

variable "schedule_expression_timezone" {
  description = "Timezone in which the scheduling expression is evaluated. Defaults to UTC."
  type        = string
  default     = "UTC"
}

variable "start_date" {
  description = "The date, in UTC, after which the schedule can begin invoking its target."
  type        = string
  default     = null

  validation {
    condition     = var.start_date == null || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.start_date))
    error_message = "resource_aws_scheduler_schedule, start_date must be in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "end_date" {
  description = "The date, in UTC, before which the schedule can invoke its target."
  type        = string
  default     = null

  validation {
    condition     = var.end_date == null || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.end_date))
    error_message = "resource_aws_scheduler_schedule, end_date must be in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "state" {
  description = "Specifies whether the schedule is enabled or disabled."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "resource_aws_scheduler_schedule, state must be either ENABLED or DISABLED."
  }
}

variable "kms_key_arn" {
  description = "ARN for the customer managed KMS key that EventBridge Scheduler will use to encrypt and decrypt your data."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_arn))
    error_message = "resource_aws_scheduler_schedule, kms_key_arn must be a valid KMS key ARN."
  }
}

variable "flexible_time_window" {
  description = "Configures a time window during which EventBridge Scheduler invokes the schedule."
  type = object({
    mode                      = string
    maximum_window_in_minutes = optional(number)
  })

  validation {
    condition     = contains(["OFF", "FLEXIBLE"], var.flexible_time_window.mode)
    error_message = "resource_aws_scheduler_schedule, flexible_time_window.mode must be either OFF or FLEXIBLE."
  }

  validation {
    condition = var.flexible_time_window.maximum_window_in_minutes == null || (
      var.flexible_time_window.maximum_window_in_minutes >= 1 &&
      var.flexible_time_window.maximum_window_in_minutes <= 1440
    )
    error_message = "resource_aws_scheduler_schedule, flexible_time_window.maximum_window_in_minutes must be between 1 and 1440 minutes."
  }
}

variable "target" {
  description = "Configures the target of the schedule."
  type = object({
    arn      = string
    role_arn = string
    input    = optional(string)
    dead_letter_config = optional(object({
      arn = string
    }))
    ecs_parameters = optional(object({
      task_definition_arn     = string
      enable_ecs_managed_tags = optional(bool)
      enable_execute_command  = optional(bool)
      group                   = optional(string)
      launch_type             = optional(string)
      platform_version        = optional(string)
      propagate_tags          = optional(string)
      reference_id            = optional(string)
      tags                    = optional(map(string))
      task_count              = optional(number)
      capacity_provider_strategy = optional(list(object({
        capacity_provider = string
        base              = optional(number)
        weight            = optional(number)
      })))
      network_configuration = optional(object({
        assign_public_ip = optional(bool)
        security_groups  = optional(set(string))
        subnets          = optional(set(string))
      }))
      placement_constraints = optional(list(object({
        expression = optional(string)
        type       = string
      })))
      placement_strategy = optional(list(object({
        field = optional(string)
        type  = string
      })))
    }))
    eventbridge_parameters = optional(object({
      detail_type = string
      source      = string
    }))
    kinesis_parameters = optional(object({
      partition_key = string
    }))
    retry_policy = optional(object({
      maximum_event_age_in_seconds = optional(number)
      maximum_retry_attempts       = optional(number)
    }))
    sagemaker_pipeline_parameters = optional(object({
      pipeline_parameter = optional(list(object({
        name  = string
        value = string
      })))
    }))
    sqs_parameters = optional(object({
      message_group_id = optional(string)
    }))
  })

  validation {
    condition     = can(regex("^arn:aws:", var.target.arn))
    error_message = "resource_aws_scheduler_schedule, target.arn must be a valid ARN."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.target.role_arn))
    error_message = "resource_aws_scheduler_schedule, target.role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.group == null || (
      length(var.target.ecs_parameters.group) <= 255
    )
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.group must be at most 255 characters."
  }

  validation {
    condition     = var.target.ecs_parameters == null || var.target.ecs_parameters.launch_type == null || contains(["EC2", "FARGATE", "EXTERNAL"], var.target.ecs_parameters.launch_type)
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.launch_type must be one of EC2, FARGATE, or EXTERNAL."
  }

  validation {
    condition     = var.target.ecs_parameters == null || var.target.ecs_parameters.propagate_tags == null || contains(["TASK_DEFINITION"], var.target.ecs_parameters.propagate_tags)
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.propagate_tags must be TASK_DEFINITION."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.task_count == null || (
      var.target.ecs_parameters.task_count >= 1 &&
      var.target.ecs_parameters.task_count <= 10
    )
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.task_count must be between 1 and 10."
  }

  validation {
    condition     = var.target.ecs_parameters == null || var.target.ecs_parameters.capacity_provider_strategy == null || length(var.target.ecs_parameters.capacity_provider_strategy) <= 6
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.capacity_provider_strategy must have at most 6 items."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.network_configuration == null || var.target.ecs_parameters.network_configuration.security_groups == null || (
      length(var.target.ecs_parameters.network_configuration.security_groups) >= 1 &&
      length(var.target.ecs_parameters.network_configuration.security_groups) <= 5
    )
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.network_configuration.security_groups must have 1 to 5 items."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.network_configuration == null || var.target.ecs_parameters.network_configuration.subnets == null || (
      length(var.target.ecs_parameters.network_configuration.subnets) >= 1 &&
      length(var.target.ecs_parameters.network_configuration.subnets) <= 16
    )
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.network_configuration.subnets must have 1 to 16 items."
  }

  validation {
    condition     = var.target.ecs_parameters == null || var.target.ecs_parameters.placement_constraints == null || length(var.target.ecs_parameters.placement_constraints) <= 10
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.placement_constraints must have at most 10 items."
  }

  validation {
    condition     = var.target.ecs_parameters == null || var.target.ecs_parameters.placement_strategy == null || length(var.target.ecs_parameters.placement_strategy) <= 5
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.placement_strategy must have at most 5 items."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.capacity_provider_strategy == null || alltrue([
      for strategy in var.target.ecs_parameters.capacity_provider_strategy :
      strategy.base == null || (strategy.base >= 0 && strategy.base <= 100000)
    ])
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.capacity_provider_strategy.base must be between 0 and 100000."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.capacity_provider_strategy == null || alltrue([
      for strategy in var.target.ecs_parameters.capacity_provider_strategy :
      strategy.weight == null || (strategy.weight >= 0 && strategy.weight <= 1000)
    ])
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.capacity_provider_strategy.weight must be between 0 and 1000."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.placement_constraints == null || alltrue([
      for constraint in var.target.ecs_parameters.placement_constraints :
      contains(["distinctInstance", "memberOf"], constraint.type)
    ])
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.placement_constraints.type must be either distinctInstance or memberOf."
  }

  validation {
    condition = var.target.ecs_parameters == null || var.target.ecs_parameters.placement_strategy == null || alltrue([
      for strategy in var.target.ecs_parameters.placement_strategy :
      contains(["random", "spread", "binpack"], strategy.type)
    ])
    error_message = "resource_aws_scheduler_schedule, target.ecs_parameters.placement_strategy.type must be one of random, spread, or binpack."
  }

  validation {
    condition = var.target.eventbridge_parameters == null || (
      length(var.target.eventbridge_parameters.detail_type) <= 128
    )
    error_message = "resource_aws_scheduler_schedule, target.eventbridge_parameters.detail_type must be at most 128 characters."
  }

  validation {
    condition = var.target.kinesis_parameters == null || (
      length(var.target.kinesis_parameters.partition_key) <= 256
    )
    error_message = "resource_aws_scheduler_schedule, target.kinesis_parameters.partition_key must be at most 256 characters."
  }

  validation {
    condition = var.target.retry_policy == null || var.target.retry_policy.maximum_event_age_in_seconds == null || (
      var.target.retry_policy.maximum_event_age_in_seconds >= 60 &&
      var.target.retry_policy.maximum_event_age_in_seconds <= 86400
    )
    error_message = "resource_aws_scheduler_schedule, target.retry_policy.maximum_event_age_in_seconds must be between 60 and 86400."
  }

  validation {
    condition = var.target.retry_policy == null || var.target.retry_policy.maximum_retry_attempts == null || (
      var.target.retry_policy.maximum_retry_attempts >= 0 &&
      var.target.retry_policy.maximum_retry_attempts <= 185
    )
    error_message = "resource_aws_scheduler_schedule, target.retry_policy.maximum_retry_attempts must be between 0 and 185."
  }

  validation {
    condition     = var.target.sagemaker_pipeline_parameters == null || var.target.sagemaker_pipeline_parameters.pipeline_parameter == null || length(var.target.sagemaker_pipeline_parameters.pipeline_parameter) <= 200
    error_message = "resource_aws_scheduler_schedule, target.sagemaker_pipeline_parameters.pipeline_parameter must have at most 200 items."
  }
}