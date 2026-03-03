provider "aws" {
  region = "us-east-1"  # Voice Connector is only supported in us-east-1 and us-west-2
}

# Create the AWS Chime Voice Connector
resource "aws_chime_voice_connector" "example" {
  name               = "example-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Create the Voice Connector Logging configuration
resource "aws_chime_voice_connector_logging" "example" {
  voice_connector_id        = aws_chime_voice_connector.example.id
  enable_sip_logs          = false
  enable_media_metric_logs = true
}