resource "aws_service_discovery_private_dns_namespace" "this" {
  region      = var.region
  name        = var.name
  vpc         = var.vpc
  description = var.description
  tags        = var.tags
}