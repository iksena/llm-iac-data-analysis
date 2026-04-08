resource "aws_route53_resolver_query_log_config" "this" {
  region          = var.region
  destination_arn = var.destination_arn
  name            = var.name
  tags            = var.tags
}