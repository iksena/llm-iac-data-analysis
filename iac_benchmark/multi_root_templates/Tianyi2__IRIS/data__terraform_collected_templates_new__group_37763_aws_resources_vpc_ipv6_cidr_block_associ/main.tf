resource "aws_vpc_ipv6_cidr_block_association" "this" {
  region                           = var.region
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  ipv6_cidr_block                  = var.ipv6_cidr_block
  ipv6_ipam_pool_id                = var.ipv6_ipam_pool_id
  ipv6_netmask_length              = var.ipv6_netmask_length
  ipv6_pool                        = var.ipv6_pool
  vpc_id                           = var.vpc_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}