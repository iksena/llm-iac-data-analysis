resource "aws_auditmanager_organization_admin_account_registration" "this" {
  admin_account_id = var.admin_account_id
  region           = var.region
}