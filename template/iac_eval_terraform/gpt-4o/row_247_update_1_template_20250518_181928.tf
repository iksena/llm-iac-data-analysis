provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "chime_voice_connector_role" {
  name = "ChimeVoiceConnectorRole"

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

resource "aws_iam_policy" "chime_voice_connector_policy" {
  name        = "ChimeVoiceConnectorPolicy"
  description = "Policy for Chime Voice Connector"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "chime:CreateVoiceConnector",
          "chime:DeleteVoiceConnector",
          "chime:UpdateVoiceConnector",
          "chime:GetVoiceConnector"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "chime_voice_connector_policy_attachment" {
  role       = aws_iam_role.chime_voice_connector_role.name
  policy_arn = aws_iam_policy.chime_voice_connector_policy.arn
}

resource "aws_chime_voice_connector" "voice_connector_1" {
  name       = "VoiceConnector1"
  require_encryption = true
}

resource "aws_chime_voice_connector" "voice_connector_2" {
  name       = "VoiceConnector2"
  require_encryption = true
}

resource "aws_chime_voice_connector_group" "voice_connector_group" {
  name = "VoiceConnectorGroup"

  connector {
    priority = 1
    voice_connector_id = aws_chime_voice_connector.voice_connector_1.id
  }

  connector {
    priority = 2
    voice_connector_id = aws_chime_voice_connector.voice_connector_2.id
  }
}