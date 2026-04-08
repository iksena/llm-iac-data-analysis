resource "aws_lightsail_bucket_access_key" "this" {
  bucket_name = var.bucket_name
  region      = var.region
}