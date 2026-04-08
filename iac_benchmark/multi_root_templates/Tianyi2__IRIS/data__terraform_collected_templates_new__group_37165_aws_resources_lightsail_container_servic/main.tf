resource "aws_lightsail_container_service_deployment_version" "this" {
  service_name = var.service_name

  dynamic "container" {
    for_each = var.container
    content {
      container_name = container.value.container_name
      image          = container.value.image
      command        = lookup(container.value, "command", null)
      environment    = lookup(container.value, "environment", null)
      ports          = lookup(container.value, "ports", null)
    }
  }

  dynamic "public_endpoint" {
    for_each = var.public_endpoint != null ? [var.public_endpoint] : []
    content {
      container_name = public_endpoint.value.container_name
      container_port = public_endpoint.value.container_port

      dynamic "health_check" {
        for_each = [public_endpoint.value.health_check]
        content {
          healthy_threshold   = lookup(health_check.value, "healthy_threshold", 2)
          interval_seconds    = lookup(health_check.value, "interval_seconds", 5)
          path                = lookup(health_check.value, "path", "/")
          success_codes       = lookup(health_check.value, "success_codes", "200-499")
          timeout_seconds     = lookup(health_check.value, "timeout_seconds", 2)
          unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", 2)
        }
      }
    }
  }

  region = var.region

  timeouts {
    create = var.timeouts_create
  }
}