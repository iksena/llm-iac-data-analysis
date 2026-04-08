resource "aws_waf_rule" "this" {
  metric_name = var.metric_name
  name        = var.name

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