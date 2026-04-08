resource "aws_servicecatalogappregistry_attribute_group_association" "this" {
  region             = var.region
  application_id     = var.application_id
  attribute_group_id = var.attribute_group_id
}