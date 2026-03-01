provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "example" {
  name          = "ExampleVoiceConnector"
  require_encryption = true
}

resource "aws_chime_voice_connector_logging" "example_logging" {
  voice_connector_id = aws_chime_voice_connector.example.id

  media_metrics {
    enabled = true
  }
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
  description = "Policy to allow Chime Voice Connector logging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "chime_logging_policy_attachment" {
  role       = aws_iam_role.chime_logging_role.name
  policy_arn = aws_iam_policy.chime_logging_policy.arn
}