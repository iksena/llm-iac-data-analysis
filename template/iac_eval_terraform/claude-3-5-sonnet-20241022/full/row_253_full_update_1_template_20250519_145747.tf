I'll help you create a Terraform configuration for an AWS Chime Voice Connector with encryption and streaming configuration. Here's what we'll build:

1. AWS Chime Voice Connector with encryption enabled
2. Configure streaming with a 5-hour retention period
3. Set up SNS topic for notifications
4. Disable Kinesis streaming
5. Required IAM roles and policies

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1" # Voice Connector is only available in us-east-1 and us-west-2
}

# Create SNS Topic for notifications
resource "aws_sns_topic" "voice_connector_notifications" {
  name = "voice-connector-notifications"
}

# Create IAM role for Chime Voice Connector
resource "aws_iam_role" "chime_voice_connector_role" {
  name = "chime-voice-connector-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "voiceconnector.chime.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Chime Voice Connector
resource "aws_iam_role_policy" "chime_voice_connector_policy" {
  name = "chime-voice-connector-policy"
  role = aws_iam_role.chime_voice_connector_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.voice_connector_notifications.arn
        ]
      }
    ]
  })
}

# Create AWS Chime Voice Connector
resource "aws_chime_voice_connector" "connector" {
  name               = "my-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Configure Voice Connector Streaming
resource "aws_chime_voice_connector_streaming" "connector_streaming" {
  voice_connector_id = aws_chime_voice_connector.connector.id
  
  data_retention    = 5 # 5 hours retention
  disabled          = false # Enable streaming
  streaming_notification_targets = [
    aws_sns_topic.voice_connector_notifications.arn
  ]
}

# Output the Voice Connector ID
output "voice_connector_id" {
  value = aws_chime_voice_connector.connector.id
}

# Output the Voice Connector DNS name
output "voice_connector_dns" {
  value = aws_chime_voice_connector.connector.outbound_host_name
}
</iac_template>

This Terraform configuration creates:

1. An AWS Chime Voice Connector with encryption enabled
2. An SNS topic for notifications
3. Required IAM role and policy for the Voice Connector to publish to SNS
4. Voice Connector streaming configuration with:
   - 5-hour data retention
   - Streaming enabled
   - SNS notification target
   - Kinesis streaming disabled by default (not configured)

The configuration includes outputs for the Voice Connector ID and DNS name for reference.

Note that AWS Chime Voice Connector is only available in us-east-1 and us-west-2 regions, so the provider is set to us-east-1. Make sure you have appropriate AWS credentials configured to deploy this infrastructure.