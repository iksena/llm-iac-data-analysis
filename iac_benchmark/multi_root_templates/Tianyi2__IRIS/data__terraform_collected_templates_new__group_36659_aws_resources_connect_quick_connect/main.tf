resource "aws_connect_quick_connect" "this" {
  instance_id = var.instance_id
  name        = var.name
  description = var.description

  quick_connect_config {
    quick_connect_type = var.quick_connect_config.quick_connect_type

    dynamic "phone_config" {
      for_each = var.quick_connect_config.phone_config != null ? [var.quick_connect_config.phone_config] : []
      content {
        phone_number = phone_config.value.phone_number
      }
    }

    dynamic "queue_config" {
      for_each = var.quick_connect_config.queue_config != null ? [var.quick_connect_config.queue_config] : []
      content {
        contact_flow_id = queue_config.value.contact_flow_id
        queue_id        = queue_config.value.queue_id
      }
    }

    dynamic "user_config" {
      for_each = var.quick_connect_config.user_config != null ? [var.quick_connect_config.user_config] : []
      content {
        contact_flow_id = user_config.value.contact_flow_id
        user_id         = user_config.value.user_id
      }
    }
  }

  tags = var.tags
}