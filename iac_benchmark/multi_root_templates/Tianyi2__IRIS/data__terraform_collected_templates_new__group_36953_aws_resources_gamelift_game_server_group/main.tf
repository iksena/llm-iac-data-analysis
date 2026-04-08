resource "aws_gamelift_game_server_group" "this" {
  game_server_group_name        = var.game_server_group_name
  max_size                      = var.max_size
  min_size                      = var.min_size
  role_arn                      = var.role_arn
  balancing_strategy            = var.balancing_strategy
  game_server_protection_policy = var.game_server_protection_policy
  tags                          = var.tags
  vpc_subnets                   = var.vpc_subnets

  dynamic "auto_scaling_policy" {
    for_each = var.auto_scaling_policy != null ? [var.auto_scaling_policy] : []
    content {
      estimated_instance_warmup = auto_scaling_policy.value.estimated_instance_warmup

      target_tracking_configuration {
        target_value = auto_scaling_policy.value.target_tracking_configuration.target_value
      }
    }
  }

  dynamic "instance_definition" {
    for_each = var.instance_definitions
    content {
      instance_type     = instance_definition.value.instance_type
      weighted_capacity = instance_definition.value.weighted_capacity
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = launch_template.value.id
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }
}