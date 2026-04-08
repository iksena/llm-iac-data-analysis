resource "aws_s3_bucket_policy" "this" {
  region = var.region
  bucket = var.bucket
  policy = var.policy
}