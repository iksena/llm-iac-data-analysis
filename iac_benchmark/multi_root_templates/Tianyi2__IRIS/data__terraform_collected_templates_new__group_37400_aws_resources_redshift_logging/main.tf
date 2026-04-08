resource "aws_redshift_logging" "this" {
  cluster_identifier   = var.cluster_identifier
  region               = var.region
  bucket_name          = var.bucket_name
  log_destination_type = var.log_destination_type
  log_exports          = var.log_exports
  s3_key_prefix        = var.s3_key_prefix
}