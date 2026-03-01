provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_bot_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lexv2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lex permissions to the role
resource "aws_iam_role_policy" "lex_policy" {
  name = "lex_bot_policy"
  role = aws_iam_role.lex_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "polly:SynthesizeSpeech",
          "comprehend:DetectSentiment"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Lex Bot
resource "aws_lexv2models_bot" "example_bot" {
  name = "ExampleBot"
  description = "An example Lex V2 bot created with Terraform"
  
  idle_session_ttl_in_seconds = 300
  
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = false
  }

  bot_locale {
    locale_id = "en_US"
    nlu_confidence_threshold = 0.40

    voice_settings {
      voice_id = "Salli"
    }
  }

  tags = {
    Environment = "development"
    Terraform   = "true"
  }
}

# Output the bot ID
output "bot_id" {
  value = aws_lexv2models_bot.example_bot.id
}