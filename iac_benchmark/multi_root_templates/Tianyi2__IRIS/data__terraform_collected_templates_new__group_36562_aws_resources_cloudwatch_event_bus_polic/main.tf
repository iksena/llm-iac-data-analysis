resource "aws_cloudwatch_event_bus_policy" "this" {
  region         = var.region
  policy         = var.policy
  event_bus_name = var.event_bus_name
}