resource "aws_dx_hosted_transit_virtual_interface_accepter" "this" {
  region               = var.region
  dx_gateway_id        = var.dx_gateway_id
  virtual_interface_id = var.virtual_interface_id
  tags                 = var.tags

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}