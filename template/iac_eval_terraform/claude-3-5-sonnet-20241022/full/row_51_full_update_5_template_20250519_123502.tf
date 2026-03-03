I'll create a template using the correct resource type `aws_lex_bot` for creating an Amazon Lex bot.

<iac_template>
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
          Service = "lex.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary permissions to the role
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLexFullAccess"
}

# Create Lex Bot
resource "aws_lex_bot" "example" {
  name        = "ExampleBot"
  description = "Example Bot created with Terraform"
  
  abort_statement {
    message {
      content      = "Sorry, I could not understand. Please try again."
      content_type = "PlainText"
    }
  }

  child_directed = false

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you, what would you like to do?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300

  process_behavior = "BUILD"
  voice_id        = "Salli"

  intent {
    intent_name    = "HelloWorld"
    intent_version = "1"
  }
}

# Output the bot name
output "bot_name" {
  value = aws_lex_bot.example.name
}
</iac_template>