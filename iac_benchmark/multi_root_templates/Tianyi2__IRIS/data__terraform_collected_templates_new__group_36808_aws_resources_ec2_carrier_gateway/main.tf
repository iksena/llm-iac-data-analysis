resource "aws_ec2_carrier_gateway" "this" {
  region = var.region
  tags   = var.tags
  vpc_id = var.vpc_id
}