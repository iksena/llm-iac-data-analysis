provider "aws" {
  region = "us-east-1"  # Voice Connector is supported in us-east-1
}

# Create Kinesis Stream
resource "aws_kinesis_stream" "voice_stream" {
  name             = "chime-voice-connector-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "production"
    Purpose     = "voice-connector-streaming"
  }
}

# Create IAM Role for Chime Voice Connector
resource "aws_iam_role" "chime_streaming_role" {
  name = "chime-voice-connector-streaming-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "chime.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM Policy for Kinesis access
resource "aws_iam_role_policy" "chime_streaming_policy" {
  name = "chime-voice-connector-streaming-policy"
  role = aws_iam_role.chime_streaming_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = aws_kinesis_stream.voice_stream.arn
      }
    ]
  })
}

# Create Voice Connector
resource "aws_chime_voice_connector" "connector" {
  name               = "my-voice-connector"
  require_encryption = true
}

# Configure Voice Connector Streaming
resource "aws_chime_voice_connector_streaming" "streaming" {
  voice_connector_id = aws_chime_voice_connector.connector.id
  data_retention     = 24
  streaming_notification_targets = ["SNS"]  # Changed to SNS which is a valid target
}