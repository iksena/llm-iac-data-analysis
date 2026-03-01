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

resource "aws_lex_bot" "example_bot" {
  name        = "ExampleBot"
  description = "A sample Lex bot with multiple slots"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = "OrderPizza"
    sample_utterances = [
      "I want to order a pizza",
      "Order a pizza"
    ]

    slot {
      name        = "PizzaType"
      slot_type   = "AMAZON.Food"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages {
          content_type = "PlainText"
          content      = "What type of pizza would you like?"
        }
        max_attempts = 3
      }
    }

    slot {
      name        = "PizzaSize"
      slot_type   = "AMAZON.Food"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages {
          content_type = "PlainText"
          content      = "What size of pizza would you like?"
        }
        max_attempts = 3
      }
    }
  }
}