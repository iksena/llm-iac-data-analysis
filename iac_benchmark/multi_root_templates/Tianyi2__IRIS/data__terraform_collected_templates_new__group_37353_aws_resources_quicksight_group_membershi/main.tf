resource "aws_quicksight_group_membership" "this" {
  aws_account_id = var.aws_account_id
  group_name     = var.group_name
  member_name    = var.member_name
  namespace      = var.namespace
  region         = var.region
}