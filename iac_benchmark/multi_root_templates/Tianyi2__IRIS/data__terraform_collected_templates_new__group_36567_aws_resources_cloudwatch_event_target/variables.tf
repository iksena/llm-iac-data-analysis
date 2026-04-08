variable "arn" {
  description = "The Amazon Resource Name (ARN) of the target"
  type        = string

  validation {
    condition     = length(var.arn) > 0
    error_message = "resource_aws_cloudwatch_event_target, arn must not be empty."
  }
}

variable "rule" {
  description = "The name of the rule you want to add targets to"
  type        = string

  validation {
    condition     = length(var.rule) > 0
    error_message = "resource_aws_cloudwatch_event_target, rule must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "appsync_target" {
  description = "Parameters used when you are using the rule to invoke an AppSync GraphQL API mutation"
  type = object({
    graphql_operation = optional(string)
  })
  default = null

  validation {
    condition = var.appsync_target == null ? true : (
      var.appsync_target.graphql_operation != null ? length(var.appsync_target.graphql_operation) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, appsync_target.graphql_operation must not be empty when specified."
  }
}

variable "batch_target" {
  description = "Parameters used when you are using the rule to invoke an Amazon Batch Job"
  type = object({
    job_definition = string
    job_name       = string
    array_size     = optional(number)
    job_attempts   = optional(number)
  })
  default = null

  validation {
    condition = var.batch_target == null ? true : (
      length(var.batch_target.job_definition) > 0 && length(var.batch_target.job_name) > 0
    )
    error_message = "resource_aws_cloudwatch_event_target, batch_target.job_definition and batch_target.job_name must not be empty."
  }

  validation {
    condition = var.batch_target == null ? true : (
      var.batch_target.array_size != null ? (var.batch_target.array_size >= 2 && var.batch_target.array_size <= 10000) : true
    )
    error_message = "resource_aws_cloudwatch_event_target, batch_target.array_size must be between 2 and 10,000."
  }

  validation {
    condition = var.batch_target == null ? true : (
      var.batch_target.job_attempts != null ? (var.batch_target.job_attempts >= 1 && var.batch_target.job_attempts <= 10) : true
    )
    error_message = "resource_aws_cloudwatch_event_target, batch_target.job_attempts must be between 1 and 10."
  }
}

variable "dead_letter_config" {
  description = "Parameters used when you are providing a dead letter config"
  type = object({
    arn = optional(string)
  })
  default = null

  validation {
    condition = var.dead_letter_config == null ? true : (
      var.dead_letter_config.arn != null ? length(var.dead_letter_config.arn) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, dead_letter_config.arn must not be empty when specified."
  }
}

variable "ecs_target" {
  description = "Parameters used when you are using the rule to invoke Amazon ECS Task"
  type = object({
    task_definition_arn = string
    capacity_provider_strategy = optional(list(object({
      capacity_provider = string
      weight            = number
      base              = optional(number)
    })))
    enable_ecs_managed_tags = optional(bool)
    enable_execute_command  = optional(bool)
    group                   = optional(string)
    launch_type             = optional(string)
    network_configuration = optional(object({
      subnets          = list(string)
      security_groups  = optional(list(string))
      assign_public_ip = optional(bool)
    }))
    ordered_placement_strategy = optional(list(object({
      type  = string
      field = optional(string)
    })))
    placement_constraint = optional(list(object({
      type       = string
      expression = optional(string)
    })))
    platform_version = optional(string)
    propagate_tags   = optional(string)
    task_count       = optional(number)
    tags             = optional(map(string))
  })
  default = null

  validation {
    condition     = var.ecs_target == null ? true : length(var.ecs_target.task_definition_arn) > 0
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.task_definition_arn must not be empty."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.group != null ? length(var.ecs_target.group) <= 255 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.group maximum length is 255 characters."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.launch_type != null ? contains(["EC2", "EXTERNAL", "FARGATE"], var.ecs_target.launch_type) : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.launch_type must be one of: EC2, EXTERNAL, FARGATE."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.ordered_placement_strategy != null ? length(var.ecs_target.ordered_placement_strategy) <= 5 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.ordered_placement_strategy maximum of 5 strategy rules per task."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.placement_constraint != null ? length(var.ecs_target.placement_constraint) <= 10 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.placement_constraint maximum of 10 constraints per task."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.propagate_tags != null ? var.ecs_target.propagate_tags == "TASK_DEFINITION" : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.propagate_tags only valid value is TASK_DEFINITION."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.task_count != null ? var.ecs_target.task_count >= 1 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.task_count must be at least 1."
  }

  validation {
    condition = var.ecs_target == null ? true : (
      var.ecs_target.network_configuration != null ? (
        var.ecs_target.network_configuration.assign_public_ip != null ? contains([true, false], var.ecs_target.network_configuration.assign_public_ip) : true
      ) : true
    )
    error_message = "resource_aws_cloudwatch_event_target, ecs_target.network_configuration.assign_public_ip must be true or false."
  }
}

variable "event_bus_name" {
  description = "The name or ARN of the event bus to associate with the rule. If you omit this, the default event bus is used"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Used to delete managed rules created by AWS"
  type        = bool
  default     = false
}

variable "http_target" {
  description = "Parameters used when you are using the rule to invoke an API Gateway REST endpoint"
  type = object({
    header_parameters       = optional(map(string))
    path_parameter_values   = optional(list(string))
    query_string_parameters = optional(map(string))
  })
  default = null
}

variable "input" {
  description = "Valid JSON text passed to the target. Conflicts with input_path and input_transformer"
  type        = string
  default     = null

  validation {
    condition     = var.input == null ? true : length(var.input) > 0
    error_message = "resource_aws_cloudwatch_event_target, input must not be empty when specified."
  }
}

variable "input_path" {
  description = "The value of the JSONPath that is used for extracting part of the matched event when passing it to the target. Conflicts with input and input_transformer"
  type        = string
  default     = null

  validation {
    condition     = var.input_path == null ? true : length(var.input_path) > 0
    error_message = "resource_aws_cloudwatch_event_target, input_path must not be empty when specified."
  }
}

variable "input_transformer" {
  description = "Parameters used when you are providing a custom input to a target based on certain event data. Conflicts with input and input_path"
  type = object({
    input_template = string
    input_paths    = optional(map(string))
  })
  default = null

  validation {
    condition     = var.input_transformer == null ? true : length(var.input_transformer.input_template) > 0
    error_message = "resource_aws_cloudwatch_event_target, input_transformer.input_template must not be empty."
  }

  validation {
    condition = var.input_transformer == null ? true : (
      var.input_transformer.input_paths != null ? length(var.input_transformer.input_paths) <= 100 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, input_transformer.input_paths can have maximum of 100 key-value pairs."
  }
}

variable "kinesis_target" {
  description = "Parameters used when you are using the rule to invoke an Amazon Kinesis Stream"
  type = object({
    partition_key_path = optional(string)
  })
  default = null

  validation {
    condition = var.kinesis_target == null ? true : (
      var.kinesis_target.partition_key_path != null ? length(var.kinesis_target.partition_key_path) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, kinesis_target.partition_key_path must not be empty when specified."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. Required if ecs_target is used or target in arn is EC2 instance, Kinesis data stream, Step Functions state machine, or Event Bus in different account or region"
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null ? true : length(var.role_arn) > 0
    error_message = "resource_aws_cloudwatch_event_target, role_arn must not be empty when specified."
  }
}

variable "run_command_targets" {
  description = "Parameters used when you are using the rule to invoke Amazon EC2 Run Command"
  type = list(object({
    key    = string
    values = list(string)
  }))
  default = null

  validation {
    condition     = var.run_command_targets == null ? true : length(var.run_command_targets) <= 5
    error_message = "resource_aws_cloudwatch_event_target, run_command_targets maximum of 5 are allowed."
  }

  validation {
    condition = var.run_command_targets == null ? true : alltrue([
      for target in var.run_command_targets : length(target.key) > 0 && length(target.values) > 0
    ])
    error_message = "resource_aws_cloudwatch_event_target, run_command_targets.key and run_command_targets.values must not be empty."
  }
}

variable "redshift_target" {
  description = "Parameters used when you are using the rule to invoke an Amazon Redshift Statement"
  type = object({
    database            = string
    db_user             = optional(string)
    secrets_manager_arn = optional(string)
    sql                 = optional(string)
    statement_name      = optional(string)
    with_event          = optional(bool)
  })
  default = null

  validation {
    condition     = var.redshift_target == null ? true : length(var.redshift_target.database) > 0
    error_message = "resource_aws_cloudwatch_event_target, redshift_target.database must not be empty."
  }

  validation {
    condition = var.redshift_target == null ? true : (
      var.redshift_target.db_user != null ? length(var.redshift_target.db_user) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, redshift_target.db_user must not be empty when specified."
  }

  validation {
    condition = var.redshift_target == null ? true : (
      var.redshift_target.secrets_manager_arn != null ? length(var.redshift_target.secrets_manager_arn) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, redshift_target.secrets_manager_arn must not be empty when specified."
  }

  validation {
    condition = var.redshift_target == null ? true : (
      var.redshift_target.sql != null ? length(var.redshift_target.sql) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, redshift_target.sql must not be empty when specified."
  }

  validation {
    condition = var.redshift_target == null ? true : (
      var.redshift_target.statement_name != null ? length(var.redshift_target.statement_name) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, redshift_target.statement_name must not be empty when specified."
  }
}

variable "retry_policy" {
  description = "Parameters used when you are providing retry policies"
  type = object({
    maximum_event_age_in_seconds = optional(number)
    maximum_retry_attempts       = optional(number)
  })
  default = null

  validation {
    condition = var.retry_policy == null ? true : (
      var.retry_policy.maximum_event_age_in_seconds != null ? var.retry_policy.maximum_event_age_in_seconds > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, retry_policy.maximum_event_age_in_seconds must be greater than 0."
  }

  validation {
    condition = var.retry_policy == null ? true : (
      var.retry_policy.maximum_retry_attempts != null ? var.retry_policy.maximum_retry_attempts >= 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, retry_policy.maximum_retry_attempts must be 0 or greater."
  }
}

variable "sagemaker_pipeline_target" {
  description = "Parameters used when you are using the rule to invoke an Amazon SageMaker AI Pipeline"
  type = object({
    pipeline_parameter_list = optional(list(object({
      name  = string
      value = string
    })))
  })
  default = null

  validation {
    condition = var.sagemaker_pipeline_target == null ? true : (
      var.sagemaker_pipeline_target.pipeline_parameter_list != null ? alltrue([
        for param in var.sagemaker_pipeline_target.pipeline_parameter_list :
        length(param.name) > 0 && length(param.value) > 0
      ]) : true
    )
    error_message = "resource_aws_cloudwatch_event_target, sagemaker_pipeline_target.pipeline_parameter_list name and value must not be empty."
  }
}

variable "sqs_target" {
  description = "Parameters used when you are using the rule to invoke an Amazon SQS Queue"
  type = object({
    message_group_id = optional(string)
  })
  default = null

  validation {
    condition = var.sqs_target == null ? true : (
      var.sqs_target.message_group_id != null ? length(var.sqs_target.message_group_id) > 0 : true
    )
    error_message = "resource_aws_cloudwatch_event_target, sqs_target.message_group_id must not be empty when specified."
  }
}

variable "target_id" {
  description = "The unique target assignment ID. If missing, will generate a random, unique id"
  type        = string
  default     = null

  validation {
    condition     = var.target_id == null ? true : length(var.target_id) > 0
    error_message = "resource_aws_cloudwatch_event_target, target_id must not be empty when specified."
  }
}