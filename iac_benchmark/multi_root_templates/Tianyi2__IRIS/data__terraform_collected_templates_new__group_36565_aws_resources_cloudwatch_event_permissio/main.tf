resource "aws_cloudwatch_event_permission" "this" {
  region         = var.region
  principal      = var.principal
  statement_id   = var.statement_id
  action         = var.action
  event_bus_name = var.event_bus_name

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []
    content {
      key   = condition.value.key
      type  = condition.value.type
      value = condition.value.value
    }
  }
}