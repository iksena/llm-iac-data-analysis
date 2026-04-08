data "aws_route53_resolver_rule" "this" {
  region               = var.region
  domain_name          = var.domain_name
  name                 = var.name
  resolver_endpoint_id = var.resolver_endpoint_id
  resolver_rule_id     = var.resolver_rule_id
  rule_type            = var.rule_type
}