resource "aws_vpc_endpoint_security_group_association" "this" {
  region                      = var.region
  security_group_id           = var.security_group_id
  vpc_endpoint_id             = var.vpc_endpoint_id
  replace_default_association = var.replace_default_association
}