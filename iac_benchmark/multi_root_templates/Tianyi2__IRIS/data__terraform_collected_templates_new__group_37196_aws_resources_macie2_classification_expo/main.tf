resource "aws_macie2_classification_export_configuration" "this" {
  region = var.region

  s3_destination {
    bucket_name = var.s3_destination.bucket_name
    key_prefix  = var.s3_destination.key_prefix
    kms_key_arn = var.s3_destination.kms_key_arn
  }
}