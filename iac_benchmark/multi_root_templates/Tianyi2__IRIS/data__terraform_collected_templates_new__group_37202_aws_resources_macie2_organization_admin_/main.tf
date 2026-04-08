resource "aws_macie2_organization_admin_account" "this" {
  admin_account_id = var.admin_account_id
  region           = var.region
}