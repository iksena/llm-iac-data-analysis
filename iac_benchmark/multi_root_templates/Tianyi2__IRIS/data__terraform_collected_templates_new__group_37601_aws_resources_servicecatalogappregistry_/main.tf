resource "aws_servicecatalogappregistry_application" "this" {
  name        = var.name
  description = var.description
  tags        = var.tags
}