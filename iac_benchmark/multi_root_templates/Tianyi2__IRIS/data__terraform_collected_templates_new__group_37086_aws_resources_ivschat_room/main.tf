resource "aws_ivschat_room" "this" {
  region                            = var.region
  logging_configuration_identifiers = var.logging_configuration_identifiers
  maximum_message_length            = var.maximum_message_length
  maximum_message_rate_per_second   = var.maximum_message_rate_per_second
  name                              = var.name
  tags                              = var.tags

  dynamic "message_review_handler" {
    for_each = var.message_review_handler != null ? [var.message_review_handler] : []
    content {
      fallback_result = message_review_handler.value.fallback_result
      uri             = message_review_handler.value.uri
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}