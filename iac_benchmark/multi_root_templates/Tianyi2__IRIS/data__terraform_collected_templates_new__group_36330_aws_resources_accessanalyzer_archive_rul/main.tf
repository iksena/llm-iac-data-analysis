resource "aws_accessanalyzer_archive_rule" "this" {
  region        = var.region
  analyzer_name = var.analyzer_name
  rule_name     = var.rule_name

  dynamic "filter" {
    for_each = var.filter
    content {
      criteria = filter.value.criteria
      contains = filter.value.contains
      eq       = filter.value.eq
      exists   = filter.value.exists
      neq      = filter.value.neq
    }
  }
}