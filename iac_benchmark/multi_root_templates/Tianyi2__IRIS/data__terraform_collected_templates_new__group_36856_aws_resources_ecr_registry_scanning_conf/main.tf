resource "aws_ecr_registry_scanning_configuration" "this" {
  region    = var.region
  scan_type = var.scan_type

  dynamic "rule" {
    for_each = var.rule
    content {
      scan_frequency = rule.value.scan_frequency

      dynamic "repository_filter" {
        for_each = rule.value.repository_filter
        content {
          filter      = repository_filter.value.filter
          filter_type = repository_filter.value.filter_type
        }
      }
    }
  }
}