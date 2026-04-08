resource "aws_auditmanager_account_registration" "this" {
  region                  = var.region
  delegated_admin_account = var.delegated_admin_account
  deregister_on_destroy   = var.deregister_on_destroy
  kms_key                 = var.kms_key
}