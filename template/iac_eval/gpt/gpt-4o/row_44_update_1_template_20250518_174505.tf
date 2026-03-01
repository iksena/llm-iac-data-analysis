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

resource "aws_iam_policy" "lex_bot_policy" {
  name        = "LexBotPolicy"
  description = "Policy for Lex bot to access necessary resources"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:*",
          "logs:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lex_bot_policy_attachment" {
  role       = aws_iam_role.lex_bot_role.name
  policy_arn = aws_iam_policy.lex_bot_policy.arn
}

resource "aws_lex_bot" "pizza_order_bot" {
  name        = "PizzaOrderBot"
  description = "Bot to order pizza with a follow-up question"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = aws_lex_intent.pizza_order_intent.name
    intent_version = aws_lex_intent.pizza_order_intent.version
  }
}

resource "aws_lex_intent" "pizza_order_intent" {
  name        = "PizzaOrderIntent"
  description = "Intent to order pizza"

  slot {
    name        = "PizzaType"
    description = "Type of pizza to order"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
    value_elicitation_prompt {
      messages {
        content_type = "PlainText"
        content      = "What type of pizza would you like to order?"
      }
      max_attempts = 3
    }
  }

  conclusion_statement {
    messages {
      content_type = "PlainText"
      content      = "Thank you for your order. Would you like to confirm it?"
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}