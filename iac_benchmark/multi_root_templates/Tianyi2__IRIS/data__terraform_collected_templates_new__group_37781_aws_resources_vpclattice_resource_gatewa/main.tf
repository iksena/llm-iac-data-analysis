resource "aws_vpclattice_resource_gateway" "this" {
  name               = var.name
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
  region             = var.region
  ip_address_type    = var.ip_address_type
  security_group_ids = var.security_group_ids
  tags               = var.tags
}