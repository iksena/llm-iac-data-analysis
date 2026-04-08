resource "aws_networkmanager_transit_gateway_connect_peer_association" "this" {
  device_id                        = var.device_id
  global_network_id                = var.global_network_id
  transit_gateway_connect_peer_arn = var.transit_gateway_connect_peer_arn
  link_id                          = var.link_id

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}