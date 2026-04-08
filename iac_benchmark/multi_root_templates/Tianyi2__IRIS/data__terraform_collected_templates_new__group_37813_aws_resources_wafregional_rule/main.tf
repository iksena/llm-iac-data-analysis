resource "aws_wafregional_rule" "this" {
  region      = var.region
  name        = var.name
  metric_name = var.metric_name
  tags        = var.tags

  dynamic "predicate" {
    for_each = var.predicates
    content {
      type    = predicate.value.type
      data_id = predicate.value.data_id
      negated = predicate.value.negated
    }
  }
}