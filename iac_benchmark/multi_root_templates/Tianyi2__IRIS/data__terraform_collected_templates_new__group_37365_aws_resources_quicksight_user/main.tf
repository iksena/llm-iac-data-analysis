resource "aws_quicksight_user" "this" {
  email         = var.email
  identity_type = var.identity_type
  user_role     = var.user_role

  aws_account_id = var.aws_account_id
  iam_arn        = var.iam_arn
  namespace      = var.namespace
  region         = var.region
  session_name   = var.session_name
  user_name      = var.user_name
}