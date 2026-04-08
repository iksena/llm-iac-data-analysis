resource "aws_route53_resolver_rule" "this" {
  region               = var.region
  domain_name          = var.domain_name
  rule_type            = var.rule_type
  name                 = var.name
  resolver_endpoint_id = var.resolver_endpoint_id

  dynamic "target_ip" {
    for_each = var.target_ip
    content {
      ip       = target_ip.value.ip
      ipv6     = target_ip.value.ipv6
      port     = target_ip.value.port
      protocol = target_ip.value.protocol
    }
  }

  tags = var.tags
}