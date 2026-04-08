data "aws_route53_resolver_endpoint" "this" {
  region               = var.region
  resolver_endpoint_id = var.resolver_endpoint_id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}