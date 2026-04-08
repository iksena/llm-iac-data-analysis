data "aws_wafv2_rule_group" "this" {
  name   = var.name
  scope  = var.scope
  region = var.region
}