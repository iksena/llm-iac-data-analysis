resource "aws_athena_capacity_reservation" "this" {
  name        = var.name
  target_dpus = var.target_dpus
  region      = var.region
  tags        = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}