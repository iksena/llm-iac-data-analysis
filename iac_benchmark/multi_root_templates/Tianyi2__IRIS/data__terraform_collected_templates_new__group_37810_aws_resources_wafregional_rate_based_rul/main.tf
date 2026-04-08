resource "aws_wafregional_rate_based_rule" "this" {
  region      = var.region
  metric_name = var.metric_name
  name        = var.name
  rate_key    = var.rate_key
  rate_limit  = var.rate_limit
  tags        = var.tags

  dynamic "predicate" {
    for_each = var.predicate
    content {
      negated = predicate.value.negated
      data_id = predicate.value.data_id
      type    = predicate.value.type
    }
  }
}