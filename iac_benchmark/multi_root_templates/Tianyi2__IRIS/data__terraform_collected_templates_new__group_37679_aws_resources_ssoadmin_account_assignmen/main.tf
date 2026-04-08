resource "aws_ssoadmin_account_assignment" "this" {
  region             = var.region
  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_set_arn
  principal_id       = var.principal_id
  principal_type     = var.principal_type
  target_id          = var.target_id
  target_type        = var.target_type

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}