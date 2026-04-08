resource "aws_detective_organization_admin_account" "this" {
  account_id = var.account_id
  region     = var.region
}