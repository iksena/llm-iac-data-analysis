resource "aws_rbin_rule" "this" {
  description   = var.description
  resource_type = var.resource_type

  dynamic "resource_tags" {
    for_each = var.resource_tags != null ? [var.resource_tags] : []
    content {
      resource_tag_key   = resource_tags.value.resource_tag_key
      resource_tag_value = resource_tags.value.resource_tag_value
    }
  }

  dynamic "exclude_resource_tags" {
    for_each = var.exclude_resource_tags != null ? [var.exclude_resource_tags] : []
    content {
      resource_tag_key   = exclude_resource_tags.value.resource_tag_key
      resource_tag_value = exclude_resource_tags.value.resource_tag_value
    }
  }

  retention_period {
    retention_period_value = var.retention_period.retention_period_value
    retention_period_unit  = var.retention_period.retention_period_unit
  }

  dynamic "lock_configuration" {
    for_each = var.lock_configuration != null ? [var.lock_configuration] : []
    content {
      unlock_delay {
        unlock_delay_unit  = lock_configuration.value.unlock_delay.unlock_delay_unit
        unlock_delay_value = lock_configuration.value.unlock_delay.unlock_delay_value
      }
    }
  }

  tags = var.tags
}