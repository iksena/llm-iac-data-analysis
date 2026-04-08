data "aws_service_discovery_dns_namespace" "this" {
  name   = var.name
  type   = var.type
  region = var.region
}