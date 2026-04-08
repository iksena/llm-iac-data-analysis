resource "aws_codedeploy_deployment_config" "this" {
  deployment_config_name = var.deployment_config_name
  compute_platform       = var.compute_platform

  dynamic "minimum_healthy_hosts" {
    for_each = var.minimum_healthy_hosts != null ? [var.minimum_healthy_hosts] : []
    content {
      type  = minimum_healthy_hosts.value.type
      value = minimum_healthy_hosts.value.value
    }
  }

  dynamic "traffic_routing_config" {
    for_each = var.traffic_routing_config != null ? [var.traffic_routing_config] : []
    content {
      type = traffic_routing_config.value.type

      dynamic "time_based_canary" {
        for_each = traffic_routing_config.value.time_based_canary != null ? [traffic_routing_config.value.time_based_canary] : []
        content {
          interval   = time_based_canary.value.interval
          percentage = time_based_canary.value.percentage
        }
      }

      dynamic "time_based_linear" {
        for_each = traffic_routing_config.value.time_based_linear != null ? [traffic_routing_config.value.time_based_linear] : []
        content {
          interval   = time_based_linear.value.interval
          percentage = time_based_linear.value.percentage
        }
      }
    }
  }

  dynamic "zonal_config" {
    for_each = var.zonal_config != null ? [var.zonal_config] : []
    content {
      first_zone_monitor_duration_in_seconds = zonal_config.value.first_zone_monitor_duration_in_seconds
      monitor_duration_in_seconds            = zonal_config.value.monitor_duration_in_seconds

      dynamic "minimum_healthy_hosts_per_zone" {
        for_each = zonal_config.value.minimum_healthy_hosts_per_zone != null ? [zonal_config.value.minimum_healthy_hosts_per_zone] : []
        content {
          type  = minimum_healthy_hosts_per_zone.value.type
          value = minimum_healthy_hosts_per_zone.value.value
        }
      }
    }
  }
}