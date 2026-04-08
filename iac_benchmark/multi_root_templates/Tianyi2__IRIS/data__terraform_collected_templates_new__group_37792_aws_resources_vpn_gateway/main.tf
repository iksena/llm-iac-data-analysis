resource "aws_vpn_gateway" "this" {
  region            = var.region
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  tags              = var.tags
  amazon_side_asn   = var.amazon_side_asn
}