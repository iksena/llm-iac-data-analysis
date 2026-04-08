resource "aws_apprunner_vpc_ingress_connection" "this" {
  region      = var.region
  name        = var.name
  service_arn = var.service_arn

  ingress_vpc_configuration {
    vpc_id          = var.ingress_vpc_configuration.vpc_id
    vpc_endpoint_id = var.ingress_vpc_configuration.vpc_endpoint_id
  }

  tags = var.tags
}