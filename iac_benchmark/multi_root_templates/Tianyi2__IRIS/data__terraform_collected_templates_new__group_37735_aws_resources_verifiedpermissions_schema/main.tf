resource "aws_verifiedpermissions_schema" "this" {
  region          = var.region
  policy_store_id = var.policy_store_id

  definition {
    value = var.definition_value
  }
}