resource "aws_appsync_api_cache" "this" {
  region                     = var.region
  api_id                     = var.api_id
  api_caching_behavior       = var.api_caching_behavior
  type                       = var.type
  ttl                        = var.ttl
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
}