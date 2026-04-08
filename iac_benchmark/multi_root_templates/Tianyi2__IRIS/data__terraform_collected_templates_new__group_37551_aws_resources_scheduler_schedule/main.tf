resource "aws_scheduler_schedule" "this" {
  name                         = var.name
  name_prefix                  = var.name_prefix
  group_name                   = var.group_name
  description                  = var.description
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone
  start_date                   = var.start_date
  end_date                     = var.end_date
  state                        = var.state
  kms_key_arn                  = var.kms_key_arn

  flexible_time_window {
    mode                      = var.flexible_time_window.mode
    maximum_window_in_minutes = var.flexible_time_window.maximum_window_in_minutes
  }

  target {
    arn      = var.target.arn
    role_arn = var.target.role_arn
    input    = var.target.input

    dynamic "dead_letter_config" {
      for_each = var.target.dead_letter_config != null ? [var.target.dead_letter_config] : []
      content {
        arn = dead_letter_config.value.arn
      }
    }

    dynamic "ecs_parameters" {
      for_each = var.target.ecs_parameters != null ? [var.target.ecs_parameters] : []
      content {
        task_definition_arn     = ecs_parameters.value.task_definition_arn
        enable_ecs_managed_tags = ecs_parameters.value.enable_ecs_managed_tags
        enable_execute_command  = ecs_parameters.value.enable_execute_command
        group                   = ecs_parameters.value.group
        launch_type             = ecs_parameters.value.launch_type
        platform_version        = ecs_parameters.value.platform_version
        propagate_tags          = ecs_parameters.value.propagate_tags
        reference_id            = ecs_parameters.value.reference_id
        tags                    = ecs_parameters.value.tags
        task_count              = ecs_parameters.value.task_count

        dynamic "capacity_provider_strategy" {
          for_each = ecs_parameters.value.capacity_provider_strategy != null ? ecs_parameters.value.capacity_provider_strategy : []
          content {
            capacity_provider = capacity_provider_strategy.value.capacity_provider
            base              = capacity_provider_strategy.value.base
            weight            = capacity_provider_strategy.value.weight
          }
        }

        dynamic "network_configuration" {
          for_each = ecs_parameters.value.network_configuration != null ? [ecs_parameters.value.network_configuration] : []
          content {
            assign_public_ip = network_configuration.value.assign_public_ip
            security_groups  = network_configuration.value.security_groups
            subnets          = network_configuration.value.subnets
          }
        }

        dynamic "placement_constraints" {
          for_each = ecs_parameters.value.placement_constraints != null ? ecs_parameters.value.placement_constraints : []
          content {
            expression = placement_constraints.value.expression
            type       = placement_constraints.value.type
          }
        }

        dynamic "placement_strategy" {
          for_each = ecs_parameters.value.placement_strategy != null ? ecs_parameters.value.placement_strategy : []
          content {
            field = placement_strategy.value.field
            type  = placement_strategy.value.type
          }
        }
      }
    }

    dynamic "eventbridge_parameters" {
      for_each = var.target.eventbridge_parameters != null ? [var.target.eventbridge_parameters] : []
      content {
        detail_type = eventbridge_parameters.value.detail_type
        source      = eventbridge_parameters.value.source
      }
    }

    dynamic "kinesis_parameters" {
      for_each = var.target.kinesis_parameters != null ? [var.target.kinesis_parameters] : []
      content {
        partition_key = kinesis_parameters.value.partition_key
      }
    }

    dynamic "retry_policy" {
      for_each = var.target.retry_policy != null ? [var.target.retry_policy] : []
      content {
        maximum_event_age_in_seconds = retry_policy.value.maximum_event_age_in_seconds
        maximum_retry_attempts       = retry_policy.value.maximum_retry_attempts
      }
    }

    dynamic "sagemaker_pipeline_parameters" {
      for_each = var.target.sagemaker_pipeline_parameters != null ? [var.target.sagemaker_pipeline_parameters] : []
      content {
        dynamic "pipeline_parameter" {
          for_each = sagemaker_pipeline_parameters.value.pipeline_parameter != null ? sagemaker_pipeline_parameters.value.pipeline_parameter : []
          content {
            name  = pipeline_parameter.value.name
            value = pipeline_parameter.value.value
          }
        }
      }
    }

    dynamic "sqs_parameters" {
      for_each = var.target.sqs_parameters != null ? [var.target.sqs_parameters] : []
      content {
        message_group_id = sqs_parameters.value.message_group_id
      }
    }
  }
}