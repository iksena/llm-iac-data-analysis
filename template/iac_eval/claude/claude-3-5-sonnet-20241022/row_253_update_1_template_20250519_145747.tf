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