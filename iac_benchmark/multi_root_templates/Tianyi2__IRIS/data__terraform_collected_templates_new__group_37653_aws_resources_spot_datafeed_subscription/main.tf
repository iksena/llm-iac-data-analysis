resource "aws_spot_datafeed_subscription" "this" {
  region = var.region
  bucket = var.bucket
  prefix = var.prefix
}