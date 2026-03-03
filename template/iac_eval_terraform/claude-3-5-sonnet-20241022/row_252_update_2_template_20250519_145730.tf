provider "aws" {
  region = "us-east-1"  # Voice Connector is only available in specific regions
}

# Create KMS key for encryption
resource "aws_kms_key" "chime_key" {
  description             = "KMS key for Chime Voice Connector"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "voice_connector_logs" {
  name              = "/aws/chime/voiceconnector"
  retention_in_days = 30
}

# Create IAM role for Voice Connector
resource "aws_iam_role" "voice_connector_role" {
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

# Create Voice Connector
resource "aws_chime_voice_connector" "example" {
  name               = "example-voice-connector"
  require_encryption = true
  aws_region        = "us-east-1"
}

# Create Voice Connector Logging Configuration
resource "aws_chime_voice_connector_logging" "example" {
  voice_connector_id = aws_chime_voice_connector.example.id

  enable_media_metric_logs = true
  enable_sip_logs         = true
}

# Create Voice Connector Streaming Configuration
resource "aws_chime_voice_connector_streaming" "example" {
  voice_connector_id = aws_chime_voice_connector.example.id

  data_retention = 7
  streaming_notification_targets = ["SQS"]
}

# Outputs
output "voice_connector_id" {
  description = "The ID of the Voice Connector"
  value       = aws_chime_voice_connector.example.id
}