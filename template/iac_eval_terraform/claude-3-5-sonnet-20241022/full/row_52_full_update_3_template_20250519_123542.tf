I'll create a simpler, more focused template for a Lex V2 bot that follows the current AWS provider specifications.

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
          Service = "lexv2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lex permissions to the role
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexV2BotPolicy"
}

# Create the Lex V2 Bot
resource "aws_lexv2models_bot" "kids_bot" {
  name = "KidsEducationalBot"
  description = "A child-friendly educational bot"
  
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = true
  }

  bot_locale {
    locale_id = "en_US"
    description = "English US locale for kids bot"
  }
}
</iac_template>

This template includes:
1. AWS Provider configuration
2. IAM role and policy attachment for Lex V2
3. A basic Lex V2 bot configuration with:
   - Child-directed privacy settings
   - English US locale
   - 5-minute idle session timeout
   - Appropriate IAM role assignment

I've removed the bot alias and version configurations that were causing issues and focused on the core bot setup. This template should now be deployable without syntax errors.