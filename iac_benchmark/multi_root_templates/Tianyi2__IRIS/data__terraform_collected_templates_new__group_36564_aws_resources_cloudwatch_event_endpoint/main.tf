resource "aws_cloudwatch_event_endpoint" "this" {
  name        = var.name
  description = var.description
  role_arn    = var.role_arn

  dynamic "event_bus" {
    for_each = var.event_buses
    content {
      event_bus_arn = event_bus.value.event_bus_arn
    }
  }

  dynamic "replication_config" {
    for_each = var.replication_config != null ? [var.replication_config] : []
    content {
      state = replication_config.value.state
    }
  }

  routing_config {
    failover_config {
      primary {
        health_check = var.routing_config.failover_config.primary.health_check
      }

      secondary {
        route = var.routing_config.failover_config.secondary.route
      }
    }
  }
}