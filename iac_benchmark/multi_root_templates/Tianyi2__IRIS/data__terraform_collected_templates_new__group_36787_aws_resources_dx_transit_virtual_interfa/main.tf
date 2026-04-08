resource "aws_dx_transit_virtual_interface" "this" {
  region           = var.region
  address_family   = var.address_family
  bgp_asn          = var.bgp_asn
  connection_id    = var.connection_id
  dx_gateway_id    = var.dx_gateway_id
  name             = var.name
  vlan             = var.vlan
  amazon_address   = var.amazon_address
  bgp_auth_key     = var.bgp_auth_key
  customer_address = var.customer_address
  mtu              = var.mtu
  sitelink_enabled = var.sitelink_enabled
  tags             = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}