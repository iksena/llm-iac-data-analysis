resource "aws_connect_routing_profile" "this" {
  instance_id               = var.instance_id
  name                      = var.name
  default_outbound_queue_id = var.default_outbound_queue_id
  description               = var.description

  dynamic "media_concurrencies" {
    for_each = var.media_concurrencies
    content {
      channel     = media_concurrencies.value.channel
      concurrency = media_concurrencies.value.concurrency
    }
  }

  dynamic "queue_configs" {
    for_each = var.queue_configs
    content {
      channel  = queue_configs.value.channel
      delay    = queue_configs.value.delay
      priority = queue_configs.value.priority
      queue_id = queue_configs.value.queue_id
    }
  }

  tags = var.tags
}