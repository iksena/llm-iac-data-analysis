resource "aws_iot_event_configurations" "this" {
  region               = var.region
  event_configurations = var.event_configurations
}