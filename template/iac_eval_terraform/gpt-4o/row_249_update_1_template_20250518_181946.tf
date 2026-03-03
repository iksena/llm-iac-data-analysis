provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "primary" {
  name       = "PrimaryVoiceConnector"
  aws_region = "us-east-1"
  encryption = true
}

resource "aws_chime_voice_connector" "secondary" {
  name       = "SecondaryVoiceConnector"
  aws_region = "us-east-1"
  encryption = true
}

resource "aws_chime_voice_connector_group" "voice_connector_group" {
  name = "VoiceConnectorGroup"

  connector {
    priority = 1
    voice_connector_id = aws_chime_voice_connector.primary.id
  }

  connector {
    priority = 2
    voice_connector_id = aws_chime_voice_connector.secondary.id
  }
}