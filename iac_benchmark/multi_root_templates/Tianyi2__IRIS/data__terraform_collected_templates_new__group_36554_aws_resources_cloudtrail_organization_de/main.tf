resource "aws_cloudtrail_organization_delegated_admin_account" "this" {
  account_id = var.account_id
}