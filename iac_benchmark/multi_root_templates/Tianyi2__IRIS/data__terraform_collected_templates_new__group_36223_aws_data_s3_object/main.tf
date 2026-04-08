data "aws_s3_object" "this" {
  region        = var.region
  bucket        = var.bucket
  checksum_mode = var.checksum_mode
  key           = var.key
  version_id    = var.version_id
}