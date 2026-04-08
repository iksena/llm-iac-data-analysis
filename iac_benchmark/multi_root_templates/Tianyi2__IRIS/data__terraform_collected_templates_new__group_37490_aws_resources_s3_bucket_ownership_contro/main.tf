resource "aws_s3_bucket_ownership_controls" "this" {
  region = var.region
  bucket = var.bucket

  rule {
    object_ownership = var.object_ownership
  }
}