data "aws_wafv2_regex_pattern_set" "this" {
  region = var.region
  name   = var.name
  scope  = var.scope
}