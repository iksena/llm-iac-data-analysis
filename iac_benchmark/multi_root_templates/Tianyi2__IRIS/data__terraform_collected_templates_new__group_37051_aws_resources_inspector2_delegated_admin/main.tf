resource "aws_inspector2_delegated_admin_account" "this" {
  account_id = var.account_id
  region     = var.region

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}