resource "aws_securityhub_product_subscription" "this" {
  region      = var.region
  product_arn = var.product_arn
}