resource "aws_schemas_registry" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags
}