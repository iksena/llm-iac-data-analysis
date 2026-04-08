resource "aws_glacier_vault" "this" {
  region        = var.region
  name          = var.name
  access_policy = var.access_policy
  tags          = var.tags

  dynamic "notification" {
    for_each = var.notification != null ? [var.notification] : []
    content {
      events    = notification.value.events
      sns_topic = notification.value.sns_topic
    }
  }
}