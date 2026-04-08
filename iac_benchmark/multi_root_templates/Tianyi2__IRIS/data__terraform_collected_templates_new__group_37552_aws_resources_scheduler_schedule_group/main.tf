resource "aws_scheduler_schedule_group" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  tags        = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}