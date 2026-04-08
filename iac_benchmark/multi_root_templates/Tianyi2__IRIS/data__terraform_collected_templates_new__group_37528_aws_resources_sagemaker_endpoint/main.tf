resource "aws_sagemaker_endpoint" "this" {
  region               = var.region
  endpoint_config_name = var.endpoint_config_name
  name                 = var.name
  tags                 = var.tags

  dynamic "deployment_config" {
    for_each = var.deployment_config != null ? [var.deployment_config] : []
    content {
      dynamic "blue_green_update_policy" {
        for_each = deployment_config.value.blue_green_update_policy != null ? [deployment_config.value.blue_green_update_policy] : []
        content {
          maximum_execution_timeout_in_seconds = blue_green_update_policy.value.maximum_execution_timeout_in_seconds
          termination_wait_in_seconds          = blue_green_update_policy.value.termination_wait_in_seconds

          traffic_routing_configuration {
            type                     = blue_green_update_policy.value.traffic_routing_configuration.type
            wait_interval_in_seconds = blue_green_update_policy.value.traffic_routing_configuration.wait_interval_in_seconds

            dynamic "canary_size" {
              for_each = blue_green_update_policy.value.traffic_routing_configuration.canary_size != null ? [blue_green_update_policy.value.traffic_routing_configuration.canary_size] : []
              content {
                type  = canary_size.value.type
                value = canary_size.value.value
              }
            }

            dynamic "linear_step_size" {
              for_each = blue_green_update_policy.value.traffic_routing_configuration.linear_step_size != null ? [blue_green_update_policy.value.traffic_routing_configuration.linear_step_size] : []
              content {
                type  = linear_step_size.value.type
                value = linear_step_size.value.value
              }
            }
          }
        }
      }

      dynamic "auto_rollback_configuration" {
        for_each = deployment_config.value.auto_rollback_configuration != null ? [deployment_config.value.auto_rollback_configuration] : []
        content {
          dynamic "alarms" {
            for_each = auto_rollback_configuration.value.alarms
            content {
              alarm_name = alarms.value.alarm_name
            }
          }
        }
      }

      dynamic "rolling_update_policy" {
        for_each = deployment_config.value.rolling_update_policy != null ? [deployment_config.value.rolling_update_policy] : []
        content {
          maximum_execution_timeout_in_seconds = rolling_update_policy.value.maximum_execution_timeout_in_seconds
          wait_interval_in_seconds             = rolling_update_policy.value.wait_interval_in_seconds

          maximum_batch_size {
            type  = rolling_update_policy.value.maximum_batch_size.type
            value = rolling_update_policy.value.maximum_batch_size.value
          }

          dynamic "rollback_maximum_batch_size" {
            for_each = rolling_update_policy.value.rollback_maximum_batch_size != null ? [rolling_update_policy.value.rollback_maximum_batch_size] : []
            content {
              type  = rollback_maximum_batch_size.value.type
              value = rollback_maximum_batch_size.value.value
            }
          }
        }
      }
    }
  }
}