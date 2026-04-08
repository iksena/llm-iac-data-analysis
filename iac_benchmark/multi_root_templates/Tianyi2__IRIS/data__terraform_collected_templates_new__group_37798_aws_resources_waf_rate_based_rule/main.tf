resource "aws_waf_rate_based_rule" "this" {
  name        = var.name
  metric_name = var.metric_name
  rate_key    = var.rate_key
  rate_limit  = var.rate_limit

  dynamic "predicates" {
    for_each = var.predicates
    content {
      negated = predicates.value.negated
      data_id = predicates.value.data_id
      type    = predicates.value.type
    }
  }

  tags = var.tags
}