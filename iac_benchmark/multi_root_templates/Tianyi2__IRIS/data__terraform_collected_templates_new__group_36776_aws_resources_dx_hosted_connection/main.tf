resource "aws_dx_hosted_connection" "this" {
  name             = var.name
  bandwidth        = var.bandwidth
  connection_id    = var.connection_id
  owner_account_id = var.owner_account_id
  vlan             = var.vlan
}