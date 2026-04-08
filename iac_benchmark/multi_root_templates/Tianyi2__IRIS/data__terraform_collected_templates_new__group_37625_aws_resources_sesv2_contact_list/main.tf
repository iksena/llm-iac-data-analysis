resource "aws_sesv2_contact_list" "this" {
  contact_list_name = var.contact_list_name
  description       = var.description
  tags              = var.tags

  dynamic "topic" {
    for_each = var.topics
    content {
      default_subscription_status = topic.value.default_subscription_status
      display_name                = topic.value.display_name
      topic_name                  = topic.value.topic_name
      description                 = topic.value.description
    }
  }
}