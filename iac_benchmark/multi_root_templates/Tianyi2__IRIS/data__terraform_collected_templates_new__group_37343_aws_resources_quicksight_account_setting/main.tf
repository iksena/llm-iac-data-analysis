resource "aws_quicksight_account_settings" "this" {
  aws_account_id                 = var.aws_account_id
  default_namespace              = var.default_namespace
  termination_protection_enabled = var.termination_protection_enabled
}