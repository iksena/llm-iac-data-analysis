resource "aws_verifiedpermissions_policy_template" "this" {
  policy_store_id = var.policy_store_id
  statement       = var.statement
  description     = var.description
  region          = var.region
}