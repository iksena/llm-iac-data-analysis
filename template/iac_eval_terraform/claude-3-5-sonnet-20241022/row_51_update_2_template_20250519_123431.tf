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

# Attach necessary permissions to the role
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexV2BotPolicy"
}

# Create Lex V2 Bot
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
    description = "English (US) locale for Example Bot"
  }

  type = "BOT"
}

# Output the bot ID and name
output "bot_id" {
  value = aws_lexv2models_bot.example_bot.id
  description = "The ID of the created Lex V2 bot"
}

output "bot_name" {
  value = aws_lexv2models_bot.example_bot.name
  description = "The name of the created Lex V2 bot"
}