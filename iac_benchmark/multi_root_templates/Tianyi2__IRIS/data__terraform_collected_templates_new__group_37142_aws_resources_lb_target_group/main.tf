resource "aws_lb_target_group" "this" {
  region                             = var.region
  connection_termination             = var.connection_termination
  deregistration_delay               = var.deregistration_delay
  lambda_multi_value_headers_enabled = var.lambda_multi_value_headers_enabled
  load_balancing_algorithm_type      = var.load_balancing_algorithm_type
  load_balancing_anomaly_mitigation  = var.load_balancing_anomaly_mitigation
  load_balancing_cross_zone_enabled  = var.load_balancing_cross_zone_enabled
  name_prefix                        = var.name_prefix
  name                               = var.name
  port                               = var.port
  preserve_client_ip                 = var.preserve_client_ip
  protocol_version                   = var.protocol_version
  protocol                           = var.protocol
  proxy_protocol_v2                  = var.proxy_protocol_v2
  slow_start                         = var.slow_start
  tags                               = var.tags
  target_type                        = var.target_type
  ip_address_type                    = var.ip_address_type
  vpc_id                             = var.vpc_id

  dynamic "health_check" {
    for_each = var.health_check != null ? [var.health_check] : []
    content {
      enabled             = health_check.value.enabled
      healthy_threshold   = health_check.value.healthy_threshold
      interval            = health_check.value.interval
      matcher             = health_check.value.matcher
      path                = health_check.value.path
      port                = health_check.value.port
      protocol            = health_check.value.protocol
      timeout             = health_check.value.timeout
      unhealthy_threshold = health_check.value.unhealthy_threshold
    }
  }

  dynamic "stickiness" {
    for_each = var.stickiness != null ? [var.stickiness] : []
    content {
      cookie_duration = stickiness.value.cookie_duration
      cookie_name     = stickiness.value.cookie_name
      enabled         = stickiness.value.enabled
      type            = stickiness.value.type
    }
  }

  dynamic "target_failover" {
    for_each = var.target_failover != null ? [var.target_failover] : []
    content {
      on_deregistration = target_failover.value.on_deregistration
      on_unhealthy      = target_failover.value.on_unhealthy
    }
  }

  dynamic "target_health_state" {
    for_each = var.target_health_state != null ? [var.target_health_state] : []
    content {
      enable_unhealthy_connection_termination = target_health_state.value.enable_unhealthy_connection_termination
      unhealthy_draining_interval             = target_health_state.value.unhealthy_draining_interval
    }
  }

  dynamic "target_group_health" {
    for_each = var.target_group_health != null ? [var.target_group_health] : []
    content {
      dynamic "dns_failover" {
        for_each = target_group_health.value.dns_failover != null ? [target_group_health.value.dns_failover] : []
        content {
          minimum_healthy_targets_count      = dns_failover.value.minimum_healthy_targets_count
          minimum_healthy_targets_percentage = dns_failover.value.minimum_healthy_targets_percentage
        }
      }

      dynamic "unhealthy_state_routing" {
        for_each = target_group_health.value.unhealthy_state_routing != null ? [target_group_health.value.unhealthy_state_routing] : []
        content {
          minimum_healthy_targets_count      = unhealthy_state_routing.value.minimum_healthy_targets_count
          minimum_healthy_targets_percentage = unhealthy_state_routing.value.minimum_healthy_targets_percentage
        }
      }
    }
  }
}