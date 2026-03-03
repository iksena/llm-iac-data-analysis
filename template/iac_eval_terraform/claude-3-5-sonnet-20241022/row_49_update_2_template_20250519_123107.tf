provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_bot_role" {
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

# Create IAM policy for Lex
resource "aws_iam_role_policy" "lex_bot_policy" {
  name = "lex_pizza_bot_policy"
  role = aws_iam_role.lex_bot_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lexv2:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Lex V2 Bot
resource "aws_lexv2models_bot" "pizza_ordering_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  role_arn = aws_iam_role.lex_bot_role.arn

  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = false
  }

  nlu_confidence_threshold = 0.5

  bot_locale {
    locale_id = "en_US"
    nlu_confidence_threshold = 0.5
  }
}

# Output the bot ID
output "lex_bot_id" {
  value = aws_lexv2models_bot.pizza_ordering_bot.id
}