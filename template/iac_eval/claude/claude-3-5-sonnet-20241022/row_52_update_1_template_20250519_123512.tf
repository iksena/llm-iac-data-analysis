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
  
  data_privacy {
    child_directed = true
  }

  idle_session_ttl_in_seconds = 300

  role_arn = aws_iam_role.lex_role.arn

  type = "BOT"

  description = "A child-friendly educational bot"

  bot_locale {
    locale_id = "en_US"
    nlu_confidence_threshold = 0.40

    voice_settings {
      voice_id = "Ivy"  # A friendly voice suitable for children
    }
  }
}

# Create test version of the bot
resource "aws_lexv2models_bot_version" "test" {
  bot_id = aws_lexv2models_bot.kids_bot.id
  description = "Test version of kids bot"
}

# Create bot alias
resource "aws_lexv2models_bot_alias" "test" {
  bot_alias_name = "TestAlias"
  bot_alias_locale_settings {
    bot_alias_locale_setting {
      locale_id = "en_US"
      enabled   = true
    }
  }
  bot_id      = aws_lexv2models_bot.kids_bot.id
  bot_version = aws_lexv2models_bot_version.test.bot_version
  description = "Test alias for kids bot"
}