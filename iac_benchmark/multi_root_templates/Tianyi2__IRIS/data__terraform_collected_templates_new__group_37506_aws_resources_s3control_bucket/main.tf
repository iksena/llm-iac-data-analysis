resource "aws_s3control_bucket" "this" {
  region     = var.region
  bucket     = var.bucket
  outpost_id = var.outpost_id
  tags       = var.tags
}