data "aws_servicecatalogappregistry_attribute_group" "this" {
  arn    = var.arn
  id     = var.id
  name   = var.name
  region = var.region
}

check "identifier_validation" {
  assert {
    condition     = local.identifier_count == 1
    error_message = "data_aws_servicecatalogappregistry_attribute_group: exactly one of arn, id, or name must be set."
  }
}