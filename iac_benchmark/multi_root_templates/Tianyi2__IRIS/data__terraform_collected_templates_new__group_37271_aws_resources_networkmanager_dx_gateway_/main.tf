resource "aws_networkmanager_dx_gateway_attachment" "this" {
  core_network_id            = var.core_network_id
  direct_connect_gateway_arn = var.direct_connect_gateway_arn
  edge_locations             = var.edge_locations
  tags                       = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}