resource "aws_devicefarm_network_profile" "this" {
  name                    = var.name
  project_arn             = var.project_arn
  region                  = var.region
  description             = var.description
  downlink_bandwidth_bits = var.downlink_bandwidth_bits
  downlink_delay_ms       = var.downlink_delay_ms
  downlink_jitter_ms      = var.downlink_jitter_ms
  downlink_loss_percent   = var.downlink_loss_percent
  uplink_bandwidth_bits   = var.uplink_bandwidth_bits
  uplink_delay_ms         = var.uplink_delay_ms
  uplink_jitter_ms        = var.uplink_jitter_ms
  uplink_loss_percent     = var.uplink_loss_percent
  type                    = var.type
  tags                    = var.tags
}