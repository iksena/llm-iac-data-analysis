resource "aws_prometheus_workspace_configuration" "this" {
  workspace_id             = var.workspace_id
  region                   = var.region
  retention_period_in_days = var.retention_period_in_days

  dynamic "limits_per_label_set" {
    for_each = var.limits_per_label_set
    content {
      label_set = limits_per_label_set.value.label_set
      limits {
        max_series = limits_per_label_set.value.limits.max_series
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
    }
  }
}