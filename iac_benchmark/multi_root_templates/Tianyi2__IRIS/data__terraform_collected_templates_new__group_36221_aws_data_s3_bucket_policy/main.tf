data "aws_s3_bucket_policy" "this" {
  bucket = var.bucket
  region = var.region
}