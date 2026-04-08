resource "aws_route53recoveryreadiness_readiness_check" "this" {
  readiness_check_name = var.readiness_check_name
  resource_set_name    = var.resource_set_name
  tags                 = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      delete = timeouts.value.delete
    }
  }
}