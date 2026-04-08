resource "aws_servicecatalogappregistry_attribute_group" "this" {
  name        = var.name
  attributes  = var.attributes
  region      = var.region
  description = var.description
  tags        = var.tags
}