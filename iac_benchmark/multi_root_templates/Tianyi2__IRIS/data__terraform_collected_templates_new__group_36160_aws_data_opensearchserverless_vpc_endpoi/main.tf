data "aws_opensearchserverless_vpc_endpoint" "this" {
  region          = var.region
  vpc_endpoint_id = var.vpc_endpoint_id
}