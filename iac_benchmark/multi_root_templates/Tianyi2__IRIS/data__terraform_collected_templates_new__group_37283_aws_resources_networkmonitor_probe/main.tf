resource "aws_networkmonitor_probe" "this" {
  region           = var.region
  destination      = var.destination
  destination_port = var.destination_port
  monitor_name     = var.monitor_name
  protocol         = var.protocol
  source_arn       = var.source_arn
  packet_size      = var.packet_size
  tags             = var.tags
}