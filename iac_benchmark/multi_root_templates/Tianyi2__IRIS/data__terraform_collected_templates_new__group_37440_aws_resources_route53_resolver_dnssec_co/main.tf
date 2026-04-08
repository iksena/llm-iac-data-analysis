resource "aws_route53_resolver_dnssec_config" "this" {
  region      = var.region
  resource_id = var.resource_id
}