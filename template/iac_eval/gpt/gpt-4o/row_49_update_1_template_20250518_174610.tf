provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_bot_role" {
  name = "LexBotRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lex_bot_policy" {
  name   = "LexBotPolicy"
  role   = aws_iam_role.lex_bot_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "pizza_ordering_bot" {
  name        = "PizzaOrderingBot"
  description = "A bot to order pizzas"
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = "OrderPizza"
    intent_version = "$LATEST"
  }

  nlu_intent_confidence_threshold = 0.5
  voice_id = "Joanna"
  idle_session_ttl_in_seconds = 300

  role_arn = aws_iam_role.lex_bot_role.arn
}

resource "aws_lex_intent" "order_pizza_intent" {
  name        = "OrderPizza"
  description = "Intent to order a pizza"

  sample_utterances = [
    "I want to order a pizza",
    "Order a pizza",
    "Can I get a pizza?"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}