resource "aws_gamelift_fleet" "this" {
  region                             = var.region
  build_id                           = var.build_id
  description                        = var.description
  ec2_instance_type                  = var.ec2_instance_type
  fleet_type                         = var.fleet_type
  instance_role_arn                  = var.instance_role_arn
  metric_groups                      = var.metric_groups
  name                               = var.name
  new_game_session_protection_policy = var.new_game_session_protection_policy
  script_id                          = var.script_id
  tags                               = var.tags

  dynamic "certificate_configuration" {
    for_each = var.certificate_configuration != null ? [var.certificate_configuration] : []
    content {
      certificate_type = certificate_configuration.value.certificate_type
    }
  }

  dynamic "ec2_inbound_permission" {
    for_each = var.ec2_inbound_permission
    content {
      from_port = ec2_inbound_permission.value.from_port
      ip_range  = ec2_inbound_permission.value.ip_range
      protocol  = ec2_inbound_permission.value.protocol
      to_port   = ec2_inbound_permission.value.to_port
    }
  }

  dynamic "resource_creation_limit_policy" {
    for_each = var.resource_creation_limit_policy != null ? [var.resource_creation_limit_policy] : []
    content {
      new_game_sessions_per_creator = resource_creation_limit_policy.value.new_game_sessions_per_creator
      policy_period_in_minutes      = resource_creation_limit_policy.value.policy_period_in_minutes
    }
  }

  dynamic "runtime_configuration" {
    for_each = var.runtime_configuration != null ? [var.runtime_configuration] : []
    content {
      game_session_activation_timeout_seconds = runtime_configuration.value.game_session_activation_timeout_seconds
      max_concurrent_game_session_activations = runtime_configuration.value.max_concurrent_game_session_activations

      dynamic "server_process" {
        for_each = runtime_configuration.value.server_process != null ? runtime_configuration.value.server_process : []
        content {
          concurrent_executions = server_process.value.concurrent_executions
          launch_path           = server_process.value.launch_path
          parameters            = server_process.value.parameters
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}