resource "aws_wafregional_rule_group" "this" {
  region      = var.region
  name        = var.name
  metric_name = var.metric_name
  tags        = var.tags

  dynamic "activated_rule" {
    for_each = var.activated_rule
    content {
      action {
        type = activated_rule.value.action.type
      }
      priority = activated_rule.value.priority
      rule_id  = activated_rule.value.rule_id
      type     = activated_rule.value.type
    }
  }
}