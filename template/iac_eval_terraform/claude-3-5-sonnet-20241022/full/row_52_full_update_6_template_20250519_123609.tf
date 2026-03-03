I'll help you create a complete and valid template for a Lex bot with all required arguments:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_kids_bot_role"

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
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexBotPolicy"
}

# Create the Lex Bot
resource "aws_lex_bot" "kids_bot" {
  name = "KidsEducationalBot"
  description = "A child-friendly educational bot"
  
  child_directed = true
  
  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding. Could you try again?"
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't quite understand. Could you please repeat that?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  process_behavior            = "BUILD"
  voice_id                   = "Ivy"

  intent {
    intent_name    = "HelloIntent"
    intent_version = "1"
  }
}

# Create bot alias
resource "aws_lex_bot_alias" "test_alias" {
  bot_name    = aws_lex_bot.kids_bot.name
  description = "Test alias for kids bot"
  name        = "TestAlias"
  bot_version = "$LATEST"
}
</iac_template>