provider "aws" {
  region = "us-east-1" # AWS Chime Voice Connector is only available in us-east-1
}

# Create the Voice Connector
resource "aws_chime_voice_connector" "connector" {
  name               = "my-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "voice_connector_logs" {
  name              = "/aws/chime/voiceconnector/${aws_chime_voice_connector.connector.name}"
  retention_in_days = 30
}

# Create IAM Role for Voice Connector Logging
resource "aws_iam_role" "voice_connector_logging" {
  name = "chime-voice-connector-logging-role"

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

# Create IAM Policy for Voice Connector Logging
resource "aws_iam_role_policy" "voice_connector_logging" {
  name = "chime-voice-connector-logging-policy"
  role = aws_iam_role.voice_connector_logging.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.voice_connector_logs.arn}:*"
      }
    ]
  })
}

# Enable Voice Connector Logging
resource "aws_chime_voice_connector_logging" "example" {
  voice_connector_id = aws_chime_voice_connector.connector.id

  enable_media_metric_logs = true
  enable_sip_logs         = false

  depends_on = [
    aws_iam_role.voice_connector_logging,
    aws_iam_role_policy.voice_connector_logging
  ]
}