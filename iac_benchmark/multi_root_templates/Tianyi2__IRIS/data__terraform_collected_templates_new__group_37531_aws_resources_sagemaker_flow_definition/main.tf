resource "aws_sagemaker_flow_definition" "this" {
  flow_definition_name = var.flow_definition_name
  role_arn             = var.role_arn
  region               = var.region
  tags                 = var.tags

  human_loop_config {
    human_task_ui_arn                     = var.human_loop_config.human_task_ui_arn
    task_availability_lifetime_in_seconds = var.human_loop_config.task_availability_lifetime_in_seconds
    task_count                            = var.human_loop_config.task_count
    task_description                      = var.human_loop_config.task_description
    task_title                            = var.human_loop_config.task_title
    workteam_arn                          = var.human_loop_config.workteam_arn
    task_keywords                         = var.human_loop_config.task_keywords
    task_time_limit_in_seconds            = var.human_loop_config.task_time_limit_in_seconds

    dynamic "public_workforce_task_price" {
      for_each = var.human_loop_config.public_workforce_task_price != null ? [var.human_loop_config.public_workforce_task_price] : []
      content {
        dynamic "amount_in_usd" {
          for_each = public_workforce_task_price.value.amount_in_usd != null ? [public_workforce_task_price.value.amount_in_usd] : []
          content {
            cents                     = amount_in_usd.value.cents
            dollars                   = amount_in_usd.value.dollars
            tenth_fractions_of_a_cent = amount_in_usd.value.tenth_fractions_of_a_cent
          }
        }
      }
    }
  }

  output_config {
    s3_output_path = var.output_config.s3_output_path
    kms_key_id     = var.output_config.kms_key_id
  }

  dynamic "human_loop_activation_config" {
    for_each = var.human_loop_activation_config != null ? [var.human_loop_activation_config] : []
    content {
      human_loop_activation_conditions_config {
        human_loop_activation_conditions = human_loop_activation_config.value.human_loop_activation_conditions_config.human_loop_activation_conditions
      }
    }
  }

  dynamic "human_loop_request_source" {
    for_each = var.human_loop_request_source != null ? [var.human_loop_request_source] : []
    content {
      aws_managed_human_loop_request_source = human_loop_request_source.value.aws_managed_human_loop_request_source
    }
  }
}