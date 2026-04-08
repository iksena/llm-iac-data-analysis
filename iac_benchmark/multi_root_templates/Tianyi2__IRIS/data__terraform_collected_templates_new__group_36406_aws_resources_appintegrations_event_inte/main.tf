resource "aws_appintegrations_event_integration" "this" {
  name            = var.name
  description     = var.description
  eventbridge_bus = var.eventbridge_bus

  event_filter {
    source = var.event_filter_source
  }

  tags = var.tags
}