data "aws_route53_resolver_firewall_config" "this" {
  region      = var.region
  resource_id = var.resource_id
}