data "aws_ec2_public_ipv4_pool" "this" {
  pool_id = var.pool_id
  region  = var.region
}