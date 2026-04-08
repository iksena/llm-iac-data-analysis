data "aws_service_discovery_service" "this" {
  region       = var.region
  name         = var.name
  namespace_id = var.namespace_id
}