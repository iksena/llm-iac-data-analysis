resource "aws_dx_private_virtual_interface" "this" {
  region           = var.region
  address_family   = var.address_family
  bgp_asn          = var.bgp_asn
  connection_id    = var.connection_id
  name             = var.name
  vlan             = var.vlan
  amazon_address   = var.amazon_address
  bgp_auth_key     = var.bgp_auth_key
  customer_address = var.customer_address
  dx_gateway_id    = var.dx_gateway_id
  mtu              = var.mtu
  sitelink_enabled = var.sitelink_enabled
  tags             = var.tags
  vpn_gateway_id   = var.vpn_gateway_id

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}