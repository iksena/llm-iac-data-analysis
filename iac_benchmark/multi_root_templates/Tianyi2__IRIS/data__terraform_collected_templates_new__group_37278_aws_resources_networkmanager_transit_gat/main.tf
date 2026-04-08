resource "aws_networkmanager_transit_gateway_peering" "this" {
  core_network_id     = var.core_network_id
  transit_gateway_arn = var.transit_gateway_arn
  tags                = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}