resource "aws_chime_voice_connector_origination" "this" {
  region             = var.region
  voice_connector_id = var.voice_connector_id
  disabled           = var.disabled

  dynamic "route" {
    for_each = var.routes
    content {
      host     = route.value.host
      port     = route.value.port
      priority = route.value.priority
      protocol = route.value.protocol
      weight   = route.value.weight
    }
  }
}