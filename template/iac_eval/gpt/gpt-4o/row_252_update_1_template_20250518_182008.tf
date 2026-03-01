provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "chime_logging_role" {
  name = "ChimeLoggingRole"

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

resource "aws_iam_policy" "chime_logging_policy" {
  name        = "ChimeLoggingPolicy"
  description = "Policy to allow Chime to log media metrics to CloudWatch"

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
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_chime_logging_policy" {
  role       = aws_iam_role.chime_logging_role.name
  policy_arn = aws_iam_policy.chime_logging_policy.arn
}

resource "aws_chime_voice_connector" "voice_connector" {
  name        = "MyVoiceConnector"
  require_encryption = true
}

resource "aws_chime_voice_connector_logging" "voice_connector_logging" {
  voice_connector_id = aws_chime_voice_connector.voice_connector.id

  media_metric_logs {
    enabled = true
  }
}