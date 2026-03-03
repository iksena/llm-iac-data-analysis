I'll help you create a Terraform configuration that sets up two AWS Chime Voice Connectors with encryption and groups them together with different priorities. Here's what we'll create:

1. Two AWS Chime Voice Connectors with encryption enabled
2. An AWS Chime Voice Connector Group that includes both connectors
3. The first connector will have priority 1 (highest) and the second will have priority 10 (lower)

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This configuration:
1. Sets up the AWS provider in us-east-1 region (where AWS Chime Voice Connector is available)
2. Creates two voice connectors (primary and secondary) with encryption enabled
3. Creates a voice connector group that includes both connectors
4. Sets priority 1 for the primary connector and priority 10 for the secondary connector (lower number means higher priority)
5. Includes outputs for the IDs of both the group and individual connectors

The configuration is complete and deployable. When deployed, the primary voice connector will be preferred over the secondary one due to its higher priority (lower number). The secondary connector will be used as a fallback if needed.