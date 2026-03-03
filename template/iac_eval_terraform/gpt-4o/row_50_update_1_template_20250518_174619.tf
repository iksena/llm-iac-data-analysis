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
          "lambda:InvokeFunction"
        ]
        Resource = aws_lambda_function.pizza_order_function.arn
      }
    ]
  })
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "LambdaPolicy"
  role   = aws_iam_role.lambda_execution_role.id
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

resource "aws_lambda_function" "pizza_order_function" {
  filename         = "lambda_function_payload.zip"
  function_name    = "PizzaOrderFunction"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_lex_bot" "pizza_order_bot" {
  name        = "PizzaOrderBot"
  description = "Bot to order pizzas"
  role_arn    = aws_iam_role.lex_bot_role.arn
  intents {
    intent_name = "OrderPizza"
    intent_version = "$LATEST"
  }
  locale = "en-US"
  child_directed = false
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
    type = "CodeHook"
    code_hook {
      message_version = "1.0"
      uri             = aws_lambda_function.pizza_order_function.invoke_arn
    }
  }
  slot {
    name        = "PizzaType"
    description = "Type of pizza to order"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
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
    description = "Size of the pizza"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
    value_elicitation_prompt {
      messages {
        content_type = "PlainText"
        content      = "What size of pizza would you like?"
      }
      max_attempts = 3
    }
  }
}