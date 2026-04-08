resource "aws_inspector_assessment_template" "this" {
  region             = var.region
  name               = var.name
  target_arn         = var.target_arn
  duration           = var.duration
  rules_package_arns = var.rules_package_arns
  tags               = var.tags

  dynamic "event_subscription" {
    for_each = var.event_subscription != null ? [var.event_subscription] : []
    content {
      event     = event_subscription.value.event
      topic_arn = event_subscription.value.topic_arn
    }
  }
}