resource "aws_ivs_channel" "this" {
  region                      = var.region
  authorized                  = var.authorized
  latency_mode                = var.latency_mode
  name                        = var.name
  recording_configuration_arn = var.recording_configuration_arn
  tags                        = var.tags
  type                        = var.type

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}