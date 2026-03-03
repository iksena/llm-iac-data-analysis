I'll provide a corrected template using the proper resource type `aws_lex_bot`.

<iac_template>
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
resource "aws_iam_role_policy" "lex_bot_policy" {
  name = "lex_bot_policy"
  role = aws_iam_role.lex_bot_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lex:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Lex Bot
resource "aws_lex_bot" "demo_bot" {
  name        = "DemoBot"
  description = "A demo bot created with Terraform"
  
  abort_statement {
    message {
      content      = "Sorry, I cannot help you right now."
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

  child_directed = false
  idle_session_ttl_in_seconds = 300
  process_behavior             = "BUILD"
  voice_id                     = "Salli"

  intent {
    intent_name    = "HelloIntent"
    intent_version = "1"
  }
}

# Output the bot ID
output "bot_id" {
  value = aws_lex_bot.demo_bot.id
}
</iac_template>