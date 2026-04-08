resource "aws_route53_resolver_firewall_domain_list" "this" {
  region  = var.region
  name    = var.name
  domains = var.domains
  tags    = var.tags
}