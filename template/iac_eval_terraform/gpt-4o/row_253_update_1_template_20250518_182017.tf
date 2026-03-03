provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "example" {
  name       = "example-voice-connector"
  require_encryption = true
}

resource "aws_sns_topic" "voice_connector_notifications" {
  name = "voice-connector-notifications"
}

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

resource "aws_iam_policy" "chime_voice_connector_policy" {
  name        = "chime-voice-connector-policy"
  description = "Policy to allow Chime Voice Connector to publish to SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sns:Publish"
        Effect = "Allow"
        Resource = aws_sns_topic.voice_connector_notifications.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.chime_voice_connector_role.name
  policy_arn = aws_iam_policy.chime_voice_connector_policy.arn
}

resource "aws_chime_voice_connector_streaming" "example_streaming" {
  voice_connector_id = aws_chime_voice_connector.example.id

  streaming_configuration {
    data_retention_in_hours = 5
    disabled                = false
    streaming_notification_targets {
      notification_target = "SNS"
      target_arn          = aws_sns_topic.voice_connector_notifications.arn
    }
    streaming_notification_targets {
      notification_target = "KINESIS"
      target_arn          = ""
    }
  }
}