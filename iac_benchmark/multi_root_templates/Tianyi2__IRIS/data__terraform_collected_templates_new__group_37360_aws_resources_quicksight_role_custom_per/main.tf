resource "aws_quicksight_role_custom_permission" "this" {
  custom_permissions_name = var.custom_permissions_name
  role                    = var.role
  aws_account_id          = var.aws_account_id
  namespace               = var.namespace
  region                  = var.region
}