check "id_or_name_validation" {
  assert {
    condition     = (var.id != null && var.name == null) || (var.id == null && var.name != null)
    error_message = "Exactly one of id or name must be set."
  }
}

data "aws_servicecatalogappregistry_attribute_group_associations" "this" {
  region = var.region
  id     = var.id
  name   = var.name
}