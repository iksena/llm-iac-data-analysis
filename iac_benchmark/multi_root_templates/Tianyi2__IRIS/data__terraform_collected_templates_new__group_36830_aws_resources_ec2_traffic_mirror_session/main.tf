resource "aws_ec2_traffic_mirror_session" "this" {
  region                   = var.region
  description              = var.description
  network_interface_id     = var.network_interface_id
  traffic_mirror_filter_id = var.traffic_mirror_filter_id
  traffic_mirror_target_id = var.traffic_mirror_target_id
  packet_length            = var.packet_length
  session_number           = var.session_number
  virtual_network_id       = var.virtual_network_id
  tags                     = var.tags
}