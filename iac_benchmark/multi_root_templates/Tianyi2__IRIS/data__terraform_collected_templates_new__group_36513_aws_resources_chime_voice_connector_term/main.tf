resource "aws_chime_voice_connector_termination_credentials" "this" {
  region             = var.region
  voice_connector_id = var.voice_connector_id

  dynamic "credentials" {
    for_each = var.credentials
    content {
      username = credentials.value.username
      password = credentials.value.password
    }
  }
}