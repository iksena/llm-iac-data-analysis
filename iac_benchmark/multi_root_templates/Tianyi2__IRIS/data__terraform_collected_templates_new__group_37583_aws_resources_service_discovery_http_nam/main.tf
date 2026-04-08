resource "aws_service_discovery_http_namespace" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags
}