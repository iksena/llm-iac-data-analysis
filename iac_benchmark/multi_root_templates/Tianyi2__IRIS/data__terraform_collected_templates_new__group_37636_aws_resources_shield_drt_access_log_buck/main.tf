resource "aws_shield_drt_access_log_bucket_association" "this" {
  log_bucket              = var.log_bucket
  role_arn_association_id = var.role_arn_association_id

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}