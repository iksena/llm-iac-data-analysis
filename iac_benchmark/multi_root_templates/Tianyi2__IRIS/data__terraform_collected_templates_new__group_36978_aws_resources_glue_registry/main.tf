resource "aws_glue_registry" "this" {
  region        = var.region
  registry_name = var.registry_name
  description   = var.description
  tags          = var.tags
}