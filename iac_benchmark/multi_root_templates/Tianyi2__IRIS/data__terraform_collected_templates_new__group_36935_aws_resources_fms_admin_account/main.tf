resource "aws_fms_admin_account" "this" {
  account_id = var.account_id

  timeouts {
    create = var.timeout_create
    delete = var.timeout_delete
  }
}