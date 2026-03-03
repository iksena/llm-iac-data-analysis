provider "aws" {
  region = "us-east-1"
}

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

resource "aws_lexv2_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = false
  }

  bot_locale {
    locale_id = "en_US"
    n_lu_intent_confidence_threshold = 0.40
  }
}

resource "aws_lexv2_bot_intent" "greeting_intent" {
  bot_id      = aws_lexv2_bot.pizza_bot.id
  bot_version = "DRAFT"
  intent_name = "GreetingIntent"
  description = "Intent to handle customer greetings"

  sample_utterances {
    utterance = "Hello"
  }
  sample_utterances {
    utterance = "Hi there"
  }
  sample_utterances {
    utterance = "Good morning"
  }
}

resource "aws_lexv2_bot_intent" "order_pizza_intent" {
  bot_id      = aws_lexv2_bot.pizza_bot.id
  bot_version = "DRAFT"
  intent_name = "OrderPizzaIntent"
  description = "Intent to handle pizza ordering"

  sample_utterances {
    utterance = "I want to order a pizza"
  }
  sample_utterances {
    utterance = "Can I get a pizza"
  }
}

resource "aws_lexv2_bot_intent" "check_status_intent" {
  bot_id      = aws_lexv2_bot.pizza_bot.id
  bot_version = "DRAFT"
  intent_name = "CheckOrderStatusIntent"
  description = "Intent to check order status"

  sample_utterances {
    utterance = "Where is my order"
  }
  sample_utterances {
    utterance = "Check order status"
  }
}

resource "aws_lexv2_bot_intent" "cancel_order_intent" {
  bot_id      = aws_lexv2_bot.pizza_bot.id
  bot_version = "DRAFT"
  intent_name = "CancelOrderIntent"
  description = "Intent to cancel orders"

  sample_utterances {
    utterance = "Cancel my order"
  }
  sample_utterances {
    utterance = "I want to cancel"
  }
}

resource "aws_lexv2_bot_intent" "get_price_intent" {
  bot_id      = aws_lexv2_bot.pizza_bot.id
  bot_version = "DRAFT"
  intent_name = "GetPriceIntent"
  description = "Intent to get pizza prices"

  sample_utterances {
    utterance = "How much does it cost"
  }
  sample_utterances {
    utterance = "What are your prices"
  }
}

resource "aws_lexv2_bot_alias" "pizza_bot_alias" {
  bot_alias_name = "PizzaBotProduction"
  bot_id         = aws_lexv2_bot.pizza_bot.id
  bot_version    = "DRAFT"
}

resource "aws_iam_role_policy" "lex_policy" {
  name = "lex_bot_policy"
  role = aws_iam_role.lex_role.id

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