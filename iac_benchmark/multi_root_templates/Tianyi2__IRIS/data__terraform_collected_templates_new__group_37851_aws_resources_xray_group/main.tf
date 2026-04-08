resource "aws_xray_group" "this" {
  region            = var.region
  group_name        = var.group_name
  filter_expression = var.filter_expression
  tags              = var.tags

  dynamic "insights_configuration" {
    for_each = var.insights_configuration != null ? [var.insights_configuration] : []
    content {
      insights_enabled      = insights_configuration.value.insights_enabled
      notifications_enabled = insights_configuration.value.notifications_enabled
    }
  }
}