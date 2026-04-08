resource "aws_route53_resolver_query_log_config_association" "this" {
  region                       = var.region
  resolver_query_log_config_id = var.resolver_query_log_config_id
  resource_id                  = var.resource_id
}