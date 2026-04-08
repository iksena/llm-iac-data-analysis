resource "aws_rds_export_task" "this" {
  export_task_identifier = var.export_task_identifier
  iam_role_arn           = var.iam_role_arn
  kms_key_id             = var.kms_key_id
  s3_bucket_name         = var.s3_bucket_name
  source_arn             = var.source_arn

  region      = var.region
  export_only = var.export_only
  s3_prefix   = var.s3_prefix
}