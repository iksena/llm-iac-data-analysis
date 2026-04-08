resource "aws_vpc_endpoint_policy" "this" {
  region          = var.region
  vpc_endpoint_id = var.vpc_endpoint_id
  policy          = var.policy
}