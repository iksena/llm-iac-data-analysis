resource "aws_lightsail_bucket_resource_access" "this" {
  bucket_name   = var.bucket_name
  resource_name = var.resource_name
  region        = var.region
}