resource "aws_quicksight_role_membership" "this" {
  member_name    = var.member_name
  role           = var.role
  aws_account_id = var.aws_account_id
  namespace      = var.namespace
  region         = var.region
}