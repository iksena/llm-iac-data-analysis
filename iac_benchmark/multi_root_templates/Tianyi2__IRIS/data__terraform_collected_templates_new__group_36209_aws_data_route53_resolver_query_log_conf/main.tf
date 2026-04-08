data "aws_route53_resolver_query_log_config" "this" {
  region                       = var.region
  resolver_query_log_config_id = var.resolver_query_log_config_id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}