terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "pizza_order_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda basic execution policy attachment
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Lambda function
resource "aws_lambda_function" "pizza_order_processor" {
  filename         = "lambda_function.zip"
  function_name    = "pizza_order_processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      PIZZA_STORE_NAME = "TerraformPizza"
    }
  }
}

# IAM role for Lex
resource "aws_iam_role" "lex_role" {
  name = "pizza_order_lex_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lexv2.amazonaws.com"
      }
    }]
  })
}

# Lex Bot
resource "aws_lex_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  
  abort_statement {
    message {
      content      = "Sorry, I could not understand. Please try again."
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you, what would you like to order?"
      content_type = "PlainText"
    }
  }

  intent {
    intent_name    = "OrderPizza"
    intent_version = "1"
  }

  child_directed   = false
  process_behavior = "BUILD"
  voice_id        = "Salli"

  idle_session_ttl_in_seconds = 300
}

# Lex Intent
resource "aws_lex_intent" "order_pizza" {
  name = "OrderPizza"
  
  fulfillment_activity {
    type = "CodeHook"
    code_hook {
      message_version = "1.0"
      uri            = aws_lambda_function.pizza_order_processor.arn
    }
  }

  sample_utterances = [
    "I want to order a pizza",
    "Can I get a pizza",
    "Order pizza"
  ]
}

# Lambda permission for Lex
resource "aws_lambda_permission" "lex_lambda" {
  statement_id  = "AllowLexInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pizza_order_processor.function_name
  principal     = "lex.amazonaws.com"
  source_arn    = aws_lex_bot.pizza_bot.arn
}