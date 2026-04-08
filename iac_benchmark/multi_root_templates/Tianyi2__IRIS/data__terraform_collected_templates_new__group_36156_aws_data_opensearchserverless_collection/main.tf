locals {
  # Validation: Exactly one of id or name must be provided
  validate_inputs = (var.id == null) != (var.name == null)
}

check "exactly_one_identifier" {
  assert {
    condition     = local.validate_inputs
    error_message = "Exactly one of id or name is required for opensearchserverless_collection data source."
  }
}

data "aws_opensearchserverless_collection" "this" {
  region = var.region
  id     = var.id
  name   = var.name
}