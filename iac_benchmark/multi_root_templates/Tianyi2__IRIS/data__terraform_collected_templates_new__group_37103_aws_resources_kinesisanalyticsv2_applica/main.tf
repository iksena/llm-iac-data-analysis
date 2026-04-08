resource "aws_kinesisanalyticsv2_application_snapshot" "this" {
  application_name = var.application_name
  snapshot_name    = var.snapshot_name

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}