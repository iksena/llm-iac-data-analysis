resource "aws_dx_bgp_peer" "this" {
  address_family       = var.address_family
  bgp_asn              = var.bgp_asn
  virtual_interface_id = var.virtual_interface_id
  amazon_address       = var.amazon_address
  bgp_auth_key         = var.bgp_auth_key
  customer_address     = var.customer_address

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}