resource "aws_ssm_resource_data_sync" "this" {
  name = var.name

  s3_destination {
    bucket_name = var.s3_destination.bucket_name
    region      = var.s3_destination.region
    kms_key_arn = var.s3_destination.kms_key_arn
    prefix      = var.s3_destination.prefix
    sync_format = var.s3_destination.sync_format
  }
}