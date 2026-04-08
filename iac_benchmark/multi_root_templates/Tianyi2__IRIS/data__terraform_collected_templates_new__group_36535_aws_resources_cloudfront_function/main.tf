resource "aws_cloudfront_function" "this" {
  name    = var.name
  code    = var.code
  runtime = var.runtime

  comment                      = var.comment
  publish                      = var.publish
  key_value_store_associations = var.key_value_store_associations
}