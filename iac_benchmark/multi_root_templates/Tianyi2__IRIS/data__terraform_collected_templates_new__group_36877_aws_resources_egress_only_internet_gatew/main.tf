resource "aws_egress_only_internet_gateway" "this" {
  region = var.region
  vpc_id = var.vpc_id
  tags   = var.tags
}