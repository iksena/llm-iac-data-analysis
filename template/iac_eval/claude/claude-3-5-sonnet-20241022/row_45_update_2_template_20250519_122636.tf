provider "aws" {
  region = "us-east-1"
}

# Create IAM Role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_pizza_bot_role"

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

# Create the Lex Bot
resource "aws_lexv2models_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  role_arn = aws_iam_role.lex_role.arn
  
  idle_session_ttl_in_seconds = 300
  
  data_privacy {
    child_directed = false
  }
}

# Create Bot Locale
resource "aws_lexv2models_bot_locale" "pizza_bot_locale" {
  bot_id = aws_lexv2models_bot.pizza_bot.id
  bot_version = "DRAFT"
  locale_id = "en_US"
  
  n_lu_intent_confidence_threshold = 0.40
}

# Create Bot Alias
resource "aws_lexv2models_bot_alias" "pizza_bot_alias" {
  bot_alias_name = "PizzaBotProduction"
  bot_id         = aws_lexv2models_bot.pizza_bot.id
  bot_version    = "DRAFT"
  
  sentiment_analysis_settings {
    detect_sentiment = false
  }
}

# Create Intent
resource "aws_lexv2models_intent" "order_pizza" {
  bot_id      = aws_lexv2models_bot.pizza_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.pizza_bot_locale.locale_id
  
  intent_name = "OrderPizza"
  description = "Intent for ordering pizzas"
  
  sample_utterances {
    utterance = "I want to order a pizza"
  }
  
  sample_utterances {
    utterance = "Can I get a pizza"
  }
  
  sample_utterances {
    utterance = "I would like to order a pizza"
  }

  fulfillment_code_hook {
    enabled = false
  }

  dialog_code_hook {
    enabled = false
  }

  conclusion_statement {
    message {
      content = "Great! Your pizza order has been placed. Your pizza will be ready in 30 minutes. Thank you for ordering with us!"
      content_type = "PlainText"
    }
  }
}