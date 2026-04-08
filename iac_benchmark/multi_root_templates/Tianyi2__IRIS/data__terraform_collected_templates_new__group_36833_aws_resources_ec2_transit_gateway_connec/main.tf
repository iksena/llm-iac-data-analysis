resource "aws_ec2_transit_gateway_connect" "this" {
  region                                          = var.region
  protocol                                        = var.protocol
  tags                                            = var.tags
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  transit_gateway_id                              = var.transit_gateway_id
  transport_attachment_id                         = var.transport_attachment_id

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}