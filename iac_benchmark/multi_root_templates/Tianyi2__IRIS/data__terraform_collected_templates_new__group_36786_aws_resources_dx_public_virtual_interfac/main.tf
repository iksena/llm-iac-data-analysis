resource "aws_dx_public_virtual_interface" "this" {
  address_family        = var.address_family
  bgp_asn               = var.bgp_asn
  connection_id         = var.connection_id
  name                  = var.name
  vlan                  = var.vlan
  route_filter_prefixes = var.route_filter_prefixes

  region           = var.region
  amazon_address   = var.amazon_address
  bgp_auth_key     = var.bgp_auth_key
  customer_address = var.customer_address
  tags             = var.tags

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}