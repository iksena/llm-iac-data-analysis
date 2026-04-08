resource "aws_datasync_location_s3" "this" {
  region           = var.region
  agent_arns       = var.agent_arns
  s3_bucket_arn    = var.s3_bucket_arn
  s3_storage_class = var.s3_storage_class
  subdirectory     = var.subdirectory
  tags             = var.tags

  s3_config {
    bucket_access_role_arn = var.s3_config_bucket_access_role_arn
  }
}