resource "aws_vpc_endpoint_route_table_association" "this" {
  region          = var.region
  route_table_id  = var.route_table_id
  vpc_endpoint_id = var.vpc_endpoint_id
}