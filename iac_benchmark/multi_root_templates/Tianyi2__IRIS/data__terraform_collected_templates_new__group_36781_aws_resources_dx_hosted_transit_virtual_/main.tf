resource "aws_dx_hosted_transit_virtual_interface" "this" {
  region           = var.region
  address_family   = var.address_family
  bgp_asn          = var.bgp_asn
  connection_id    = var.connection_id
  name             = var.name
  owner_account_id = var.owner_account_id
  vlan             = var.vlan
  amazon_address   = var.amazon_address
  bgp_auth_key     = var.bgp_auth_key
  customer_address = var.customer_address
  mtu              = var.mtu

  timeouts {
    create = "10m"
    delete = "10m"
  }
}