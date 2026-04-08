resource "aws_route53_resolver_config" "this" {
  region                   = var.region
  resource_id              = var.resource_id
  autodefined_reverse_flag = var.autodefined_reverse_flag
}