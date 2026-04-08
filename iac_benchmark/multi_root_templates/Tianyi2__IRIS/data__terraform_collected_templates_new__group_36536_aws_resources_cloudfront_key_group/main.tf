resource "aws_cloudfront_key_group" "this" {
  comment = var.comment
  items   = var.items
  name    = var.name
}