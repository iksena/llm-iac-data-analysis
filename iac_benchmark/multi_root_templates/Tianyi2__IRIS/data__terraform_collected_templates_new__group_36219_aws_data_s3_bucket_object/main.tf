data "aws_s3_bucket_object" "this" {
  bucket     = var.bucket
  key        = var.key
  region     = var.region
  version_id = var.version_id
}