provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "example" {
  name          = "example-voice-connector"
  require_encryption = false
}

resource "aws_chime_voice_connector_logging" "example_logging" {
  voice_connector_id = aws_chime_voice_connector.example.id

  enable_sip_logs          = false
  enable_media_metric_logs = true
}