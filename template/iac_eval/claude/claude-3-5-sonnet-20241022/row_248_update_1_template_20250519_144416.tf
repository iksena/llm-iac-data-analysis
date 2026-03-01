provider "aws" {
  region = "us-east-1"  # AWS Chime is only available in us-east-1
}

# First Voice Connector
resource "aws_chime_voice_connector" "connector_1" {
  name               = "voice-connector-1"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Second Voice Connector
resource "aws_chime_voice_connector" "connector_2" {
  name               = "voice-connector-2"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Voice Connector Group
resource "aws_chime_voice_connector_group" "connector_group" {
  name = "voice-connector-group"

  connector {
    voice_connector_id = aws_chime_voice_connector.connector_1.id
    priority          = 1
  }

  connector {
    voice_connector_id = aws_chime_voice_connector.connector_2.id
    priority          = 3
  }
}