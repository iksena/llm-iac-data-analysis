resource "aws_schemas_schema" "this" {
  region        = var.region
  name          = var.name
  content       = var.content
  registry_name = var.registry_name
  type          = var.type
  description   = var.description
  tags          = var.tags
}