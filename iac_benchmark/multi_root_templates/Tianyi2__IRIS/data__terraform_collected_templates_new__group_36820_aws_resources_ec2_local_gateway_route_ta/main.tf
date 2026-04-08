resource "aws_ec2_local_gateway_route_table_vpc_association" "this" {
  local_gateway_route_table_id = var.local_gateway_route_table_id
  vpc_id                       = var.vpc_id
  region                       = var.region
  tags                         = var.tags
}