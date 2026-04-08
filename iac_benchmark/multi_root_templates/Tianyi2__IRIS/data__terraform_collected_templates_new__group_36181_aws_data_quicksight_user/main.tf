data "aws_quicksight_user" "this" {
  user_name      = var.user_name
  aws_account_id = var.aws_account_id
  namespace      = var.namespace
  region         = var.region
}