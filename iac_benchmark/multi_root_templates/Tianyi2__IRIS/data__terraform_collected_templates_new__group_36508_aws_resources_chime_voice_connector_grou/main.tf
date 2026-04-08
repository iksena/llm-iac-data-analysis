resource "aws_chime_voice_connector_group" "this" {
  region = var.region
  name   = var.name

  dynamic "connector" {
    for_each = var.connector
    content {
      voice_connector_id = connector.value.voice_connector_id
      priority           = connector.value.priority
    }
  }
}