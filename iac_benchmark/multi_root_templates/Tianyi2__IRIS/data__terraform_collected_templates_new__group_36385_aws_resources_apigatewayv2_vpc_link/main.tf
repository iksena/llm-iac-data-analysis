resource "aws_apigatewayv2_vpc_link" "this" {
  region             = var.region
  name               = var.name
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  tags               = var.tags
}