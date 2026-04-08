resource "aws_fis_experiment_template" "this" {
  description = var.description
  role_arn    = var.role_arn

  dynamic "experiment_options" {
    for_each = var.experiment_options != null ? [var.experiment_options] : []
    content {
      account_targeting            = experiment_options.value.account_targeting
      empty_target_resolution_mode = experiment_options.value.empty_target_resolution_mode
    }
  }

  dynamic "action" {
    for_each = var.actions
    content {
      name        = action.value.name
      action_id   = action.value.action_id
      description = action.value.description

      dynamic "parameter" {
        for_each = action.value.parameters != null ? action.value.parameters : []
        content {
          key   = parameter.value.key
          value = parameter.value.value
        }
      }

      start_after = action.value.start_after

      dynamic "target" {
        for_each = action.value.targets != null ? action.value.targets : []
        content {
          key   = target.value.key
          value = target.value.value
        }
      }
    }
  }

  dynamic "stop_condition" {
    for_each = var.stop_conditions
    content {
      source = stop_condition.value.source
      value  = stop_condition.value.value
    }
  }

  dynamic "target" {
    for_each = var.targets != null ? var.targets : []
    content {
      name           = target.value.name
      resource_type  = target.value.resource_type
      selection_mode = target.value.selection_mode
      resource_arns  = target.value.resource_arns
      parameters     = target.value.parameters

      dynamic "filter" {
        for_each = target.value.filters != null ? target.value.filters : []
        content {
          path   = filter.value.path
          values = filter.value.values
        }
      }

      dynamic "resource_tag" {
        for_each = target.value.resource_tags != null ? target.value.resource_tags : []
        content {
          key   = resource_tag.value.key
          value = resource_tag.value.value
        }
      }
    }
  }

  dynamic "log_configuration" {
    for_each = var.log_configuration != null ? [var.log_configuration] : []
    content {
      log_schema_version = log_configuration.value.log_schema_version

      dynamic "cloudwatch_logs_configuration" {
        for_each = log_configuration.value.cloudwatch_logs_configuration != null ? [log_configuration.value.cloudwatch_logs_configuration] : []
        content {
          log_group_arn = cloudwatch_logs_configuration.value.log_group_arn
        }
      }

      dynamic "s3_configuration" {
        for_each = log_configuration.value.s3_configuration != null ? [log_configuration.value.s3_configuration] : []
        content {
          bucket_name = s3_configuration.value.bucket_name
          prefix      = s3_configuration.value.prefix
        }
      }
    }
  }

  dynamic "experiment_report_configuration" {
    for_each = var.experiment_report_configuration != null ? [var.experiment_report_configuration] : []
    content {
      post_experiment_duration = experiment_report_configuration.value.post_experiment_duration
      pre_experiment_duration  = experiment_report_configuration.value.pre_experiment_duration

      data_sources {
        cloudwatch_dashboard {
          dashboard_arn = experiment_report_configuration.value.data_sources.cloudwatch_dashboard.dashboard_arn
        }
      }

      outputs {
        s3_configuration {
          bucket_name = experiment_report_configuration.value.outputs.s3_configuration.bucket_name
          prefix      = experiment_report_configuration.value.outputs.s3_configuration.prefix
        }
      }
    }
  }

  tags = var.tags
}