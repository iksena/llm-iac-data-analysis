resource "aws_cloudfront_key_value_store" "this" {
  name    = var.name
  comment = var.comment

  timeouts {
    create = var.timeouts_create
  }
}