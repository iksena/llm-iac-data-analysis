provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "chime_kinesis_role" {
  name = "ChimeKinesisRole"

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

resource "aws_iam_policy" "chime_kinesis_policy" {
  name        = "ChimeKinesisPolicy"
  description = "Policy to allow Chime Voice Connector to stream to Kinesis"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_chime_kinesis_policy" {
  role       = aws_iam_role.chime_kinesis_role.name
  policy_arn = aws_iam_policy.chime_kinesis_policy.arn
}

resource "aws_chime_voice_connector" "voice_connector" {
  name          = "MyChimeVoiceConnector"
  require_encryption = false
}

resource "aws_chime_voice_connector_streaming" "voice_connector_streaming" {
  voice_connector_id = aws_chime_voice_connector.voice_connector.id

  streaming_configuration {
    data_retention_in_hours = 24
    disabled                = false
    streaming_notification_targets = [
      {
        notification_target = "EventBridge"
      }
    ]
  }
}