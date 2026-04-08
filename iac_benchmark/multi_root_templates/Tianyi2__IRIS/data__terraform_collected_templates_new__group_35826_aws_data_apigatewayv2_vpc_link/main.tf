data "aws_apigatewayv2_vpc_link" "this" {
  region      = var.region
  vpc_link_id = var.vpc_link_id
}