resource "aws_athena_data_catalog" "this" {
  region      = var.region
  name        = var.name
  type        = var.type
  parameters  = var.parameters
  description = var.description
  tags        = var.tags
}