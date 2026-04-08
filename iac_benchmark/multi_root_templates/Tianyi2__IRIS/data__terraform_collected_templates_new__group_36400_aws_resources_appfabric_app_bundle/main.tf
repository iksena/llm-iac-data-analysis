resource "aws_appfabric_app_bundle" "this" {
  region                   = var.region
  customer_managed_key_arn = var.customer_managed_key_arn
  tags                     = var.tags
}