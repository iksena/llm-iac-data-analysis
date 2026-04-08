resource "aws_network_acl_association" "this" {
  region         = var.region
  network_acl_id = var.network_acl_id
  subnet_id      = var.subnet_id
}