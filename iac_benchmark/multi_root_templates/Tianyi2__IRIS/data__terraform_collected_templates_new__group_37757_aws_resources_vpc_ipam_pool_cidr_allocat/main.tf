resource "aws_vpc_ipam_pool_cidr_allocation" "this" {
  region           = var.region
  cidr             = var.cidr
  description      = var.description
  disallowed_cidrs = var.disallowed_cidrs
  ipam_pool_id     = var.ipam_pool_id
  netmask_length   = var.netmask_length
}