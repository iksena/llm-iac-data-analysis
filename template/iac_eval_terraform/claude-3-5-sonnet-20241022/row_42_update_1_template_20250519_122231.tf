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
          Service = "lex.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lex permissions to the role
resource "aws_iam_role_policy_attachment" "lex_basic" {
  role       = aws_iam_role.lex_bot_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexRunBotsPolicy"
}

# Create the Lex Bot
resource "aws_lex_bot" "demo_bot" {
  name = "DemoBot"
  description = "A demo bot created with Terraform"
  
  data_privacy {
    child_directed = false
  }

  idle_session_ttl_in_seconds = 300

  role_arn = aws_iam_role.lex_bot_role.arn

  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding you. Please try again."
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you. Could you please rephrase that?"
      content_type = "PlainText"
    }
  }

  voice_id = "Salli"

  nlu_intent_confidence_threshold = 0.40

  process_behavior = "BUILD"
}

# Output the bot ID
output "bot_id" {
  value = aws_lex_bot.demo_bot.id
}