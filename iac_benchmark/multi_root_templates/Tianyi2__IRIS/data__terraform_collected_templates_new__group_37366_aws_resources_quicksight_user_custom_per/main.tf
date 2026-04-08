resource "aws_quicksight_user_custom_permission" "this" {
  custom_permissions_name = var.custom_permissions_name
  user_name               = var.user_name
  aws_account_id          = var.aws_account_id
  namespace               = var.namespace
  region                  = var.region
}