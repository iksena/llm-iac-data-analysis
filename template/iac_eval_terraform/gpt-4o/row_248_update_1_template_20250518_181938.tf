provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "connector1" {
  name       = "VoiceConnector1"
  require_encryption = true
}

resource "aws_chime_voice_connector" "connector2" {
  name       = "VoiceConnector2"
  require_encryption = true
}

resource "aws_chime_voice_connector_group" "voice_connector_group" {
  name = "VoiceConnectorGroup"

  connector {
    priority = 1
    voice_connector_id = aws_chime_voice_connector.connector1.id
  }

  connector {
    priority = 3
    voice_connector_id = aws_chime_voice_connector.connector2.id
  }
}