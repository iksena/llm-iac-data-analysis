resource "aws_s3outposts_endpoint" "this" {
  region                   = var.region
  outpost_id               = var.outpost_id
  security_group_id        = var.security_group_id
  subnet_id                = var.subnet_id
  access_type              = var.access_type
  customer_owned_ipv4_pool = var.customer_owned_ipv4_pool
}