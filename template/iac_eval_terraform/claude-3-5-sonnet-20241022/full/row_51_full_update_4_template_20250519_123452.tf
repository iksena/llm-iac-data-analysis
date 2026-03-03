I apologize for the confusion. You're right. Let me correct the template using the proper resource name `aws_lexv2_bot` instead of `aws_lexv2models_bot`.

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
          Service = "lexv2.amazonaws.com"
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

# Create Lex V2 Bot
resource "aws_lexv2_bot" "example" {
  name        = "ExampleBot"
  description = "Example Bot created with Terraform"
  role_arn    = aws_iam_role.lex_role.arn

  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = false
  }

  bot_locale {
    locale_id = "en_US"
  }
}

# Output the bot ID
output "bot_id" {
  value = aws_lexv2_bot.example.id
}
</iac_template>

This template now uses the correct resource type `aws_lexv2_bot` and should work properly. The configuration creates:
1. An IAM role for the Lex bot with necessary permissions
2. A Lex V2 bot with English (US) locale
3. Basic bot settings including session timeout and data privacy settings
4. Outputs the bot ID for reference

The bot is configured with minimal settings to ensure it can be created successfully. You can extend the configuration with additional features like intents, slot types, and other advanced settings as needed.