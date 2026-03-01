provider "aws" {
  region = "us-east-1" # Voice Connector is supported in specific regions
}

# Create KMS key for encryption
resource "aws_kms_key" "chime_encryption" {
  description             = "KMS key for Chime Voice Connector encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Create KMS key alias
resource "aws_kms_alias" "chime_encryption" {
  name          = "alias/chime-voice-connector"
  target_key_id = aws_kms_key.chime_encryption.key_id
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "chime_logs" {
  name              = "/aws/chime/voice-connector"
  retention_in_days = 30
}

# Create IAM role for Chime Voice Connector
resource "aws_iam_role" "chime_voice_connector" {
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

# Create IAM policy for CloudWatch Logs
resource "aws_iam_role_policy" "chime_logging" {
  name = "chime-logging-policy"
  role = aws_iam_role.chime_voice_connector.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "${aws_cloudwatch_log_group.chime_logs.arn}",
          "${aws_cloudwatch_log_group.chime_logs.arn}:*"
        ]
      }
    ]
  })
}

# Create IAM policy for KMS encryption
resource "aws_iam_role_policy" "chime_kms" {
  name = "chime-kms-policy"
  role = aws_iam_role.chime_voice_connector.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [aws_kms_key.chime_encryption.arn]
      }
    ]
  })
}

# Create the Chime Voice Connector
resource "aws_chime_voice_connector" "connector" {
  name               = "my-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true

  encryption_config {
    kms_key = aws_kms_key.chime_encryption.arn
  }

  logging_config {
    enable_media_metric_logs = true
    enable_sip_logs         = true
  }
}

# Output the Voice Connector ID
output "voice_connector_id" {
  value = aws_chime_voice_connector.connector.id
}