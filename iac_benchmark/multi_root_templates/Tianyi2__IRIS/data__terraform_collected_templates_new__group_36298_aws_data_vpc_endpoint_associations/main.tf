data "aws_vpc_endpoint_associations" "this" {
  region          = var.region
  vpc_endpoint_id = var.vpc_endpoint_id
}