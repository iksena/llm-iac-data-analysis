resource "aws_apprunner_vpc_connector" "this" {
  region             = var.region
  vpc_connector_name = var.vpc_connector_name
  subnets            = var.subnets
  security_groups    = var.security_groups
  tags               = var.tags
}