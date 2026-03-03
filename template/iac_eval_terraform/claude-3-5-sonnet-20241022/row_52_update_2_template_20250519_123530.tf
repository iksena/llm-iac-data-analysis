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
    
    nlu_intent_confidence_threshold = 0.40
  }
}

# Create bot alias
resource "aws_lexv2models_bot_alias" "test_alias" {
  bot_alias_name = "TestAlias"
  description    = "Test alias for kids bot"
  bot_id         = aws_lexv2models_bot.kids_bot.id
  bot_version    = "DRAFT"

  sentiment_analysis_settings {
    detect_sentiment = false
  }
}