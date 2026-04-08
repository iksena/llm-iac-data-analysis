resource "aws_dx_hosted_private_virtual_interface_accepter" "this" {
  virtual_interface_id = var.virtual_interface_id
  dx_gateway_id        = var.dx_gateway_id
  vpn_gateway_id       = var.vpn_gateway_id
  tags                 = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}