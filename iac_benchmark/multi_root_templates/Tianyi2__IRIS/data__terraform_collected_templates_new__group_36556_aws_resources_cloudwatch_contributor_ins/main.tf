resource "aws_cloudwatch_contributor_insight_rule" "this" {
  rule_definition = var.rule_definition
  rule_name       = var.rule_name
  region          = var.region
  rule_state      = var.rule_state
}