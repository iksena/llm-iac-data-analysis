resource "aws_wafv2_api_key" "this" {
  region        = var.region
  scope         = var.scope
  token_domains = var.token_domains
}