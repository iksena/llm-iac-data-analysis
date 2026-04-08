data "aws_route53_resolver_rules" "this" {
  region               = var.region
  name_regex           = var.name_regex
  owner_id             = var.owner_id
  resolver_endpoint_id = var.resolver_endpoint_id
  rule_type            = var.rule_type
  share_status         = var.share_status
}