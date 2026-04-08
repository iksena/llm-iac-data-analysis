resource "aws_emrserverless_application" "this" {
  name          = var.name
  release_label = var.release_label
  type          = var.type

  region       = var.region
  architecture = var.architecture

  dynamic "auto_start_configuration" {
    for_each = var.auto_start_configuration != null ? [var.auto_start_configuration] : []
    content {
      enabled = auto_start_configuration.value.enabled
    }
  }

  dynamic "auto_stop_configuration" {
    for_each = var.auto_stop_configuration != null ? [var.auto_stop_configuration] : []
    content {
      enabled              = auto_stop_configuration.value.enabled
      idle_timeout_minutes = auto_stop_configuration.value.idle_timeout_minutes
    }
  }

  dynamic "image_configuration" {
    for_each = var.image_configuration != null ? [var.image_configuration] : []
    content {
      image_uri = image_configuration.value.image_uri
    }
  }

  dynamic "initial_capacity" {
    for_each = var.initial_capacity != null ? var.initial_capacity : []
    content {
      initial_capacity_type = initial_capacity.value.initial_capacity_type

      dynamic "initial_capacity_config" {
        for_each = initial_capacity.value.initial_capacity_config != null ? [initial_capacity.value.initial_capacity_config] : []
        content {
          worker_count = initial_capacity_config.value.worker_count

          dynamic "worker_configuration" {
            for_each = initial_capacity_config.value.worker_configuration != null ? [initial_capacity_config.value.worker_configuration] : []
            content {
              cpu    = worker_configuration.value.cpu
              memory = worker_configuration.value.memory
              disk   = worker_configuration.value.disk
            }
          }
        }
      }
    }
  }

  dynamic "interactive_configuration" {
    for_each = var.interactive_configuration != null ? [var.interactive_configuration] : []
    content {
      livy_endpoint_enabled = interactive_configuration.value.livy_endpoint_enabled
      studio_enabled        = interactive_configuration.value.studio_enabled
    }
  }

  dynamic "maximum_capacity" {
    for_each = var.maximum_capacity != null ? [var.maximum_capacity] : []
    content {
      cpu    = maximum_capacity.value.cpu
      memory = maximum_capacity.value.memory
      disk   = maximum_capacity.value.disk
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration != null ? [var.network_configuration] : []
    content {
      security_group_ids = network_configuration.value.security_group_ids
      subnet_ids         = network_configuration.value.subnet_ids
    }
  }

  tags = var.tags
}