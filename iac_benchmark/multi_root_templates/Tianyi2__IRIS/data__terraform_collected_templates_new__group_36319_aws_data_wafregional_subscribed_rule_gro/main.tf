data "aws_wafregional_subscribed_rule_group" "this" {
  region      = var.region
  name        = var.name
  metric_name = var.metric_name
}