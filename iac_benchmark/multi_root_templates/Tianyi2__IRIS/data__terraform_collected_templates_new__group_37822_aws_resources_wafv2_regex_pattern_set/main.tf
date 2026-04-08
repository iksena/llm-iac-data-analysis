resource "aws_wafv2_regex_pattern_set" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  description = var.description
  scope       = var.scope

  dynamic "regular_expression" {
    for_each = var.regular_expression
    content {
      regex_string = regular_expression.value.regex_string
    }
  }

  tags = var.tags
}