provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_bot_role" {
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
resource "aws_iam_role_policy" "lex_bot_policy" {
  name = "lex_bot_policy"
  role = aws_iam_role.lex_bot_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lexv2:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Lex Bot
resource "aws_lexv2_bot" "demo_bot" {
  name = "DemoBot"
  description = "A demo bot created with Terraform"
  
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_bot_role.arn

  data_privacy {
    child_directed = false
  }

  type = "BOT"
}

# Output the bot ID
output "bot_id" {
  value = aws_lexv2_bot.demo_bot.id
}