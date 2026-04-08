resource "aws_cloudwatch_event_rule" "this" {
  region              = var.region
  name                = var.name
  name_prefix         = var.name_prefix
  schedule_expression = var.schedule_expression
  event_bus_name      = var.event_bus_name
  event_pattern       = var.event_pattern
  force_destroy       = var.force_destroy
  description         = var.description
  role_arn            = var.role_arn
  is_enabled          = var.is_enabled
  state               = var.state
  tags                = var.tags
}