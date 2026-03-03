provider "aws" {
  region = "us-east-1"  # AWS Chime Voice Connector is only available in us-east-1 and us-west-2
}

# Create first Voice Connector
resource "aws_chime_voice_connector" "primary" {
  name               = "primary-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Create second Voice Connector
resource "aws_chime_voice_connector" "secondary" {
  name               = "secondary-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Create Voice Connector Group
resource "aws_chime_voice_connector_group" "connector_group" {
  name = "main-connector-group"

  connector {
    voice_connector_id = aws_chime_voice_connector.primary.id
    priority          = 1
  }

  connector {
    voice_connector_id = aws_chime_voice_connector.secondary.id
    priority          = 10
  }
}

# Output the Voice Connector Group ID
output "voice_connector_group_id" {
  value = aws_chime_voice_connector_group.connector_group.id
}

# Output the Primary Voice Connector ID
output "primary_voice_connector_id" {
  value = aws_chime_voice_connector.primary.id
}

# Output the Secondary Voice Connector ID
output "secondary_voice_connector_id" {
  value = aws_chime_voice_connector.secondary.id
}