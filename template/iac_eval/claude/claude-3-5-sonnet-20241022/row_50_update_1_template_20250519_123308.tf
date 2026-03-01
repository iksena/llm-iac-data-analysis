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

# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "pizza_order_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM role for Lex
resource "aws_iam_role" "lex_role" {
  name = "pizza_order_lex_role"

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

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Lambda function
resource "aws_lambda_function" "pizza_order_processor" {
  filename      = "lambda_function.zip"  # You need to create this zip file with your Lambda code
  function_name = "pizza_order_processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      PIZZA_STORE_NAME = "TerraformPizza"
    }
  }
}

# Lex Bot
resource "aws_lexv2_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  
  data_privacy {
    child_directed = false
  }

  idle_session_ttl_in_seconds = 300

  role_arn = aws_iam_role.lex_role.arn
}

# Lex Bot Version
resource "aws_lexv2_bot_version" "pizza_bot_version" {
  bot_id = aws_lexv2_bot.pizza_bot.id
  description = "Pizza ordering bot version 1"
}

# Lex Bot Locale
resource "aws_lexv2_bot_locale" "pizza_bot_locale" {
  bot_id = aws_lexv2_bot.pizza_bot.id
  bot_version = aws_lexv2_bot_version.pizza_bot_version.bot_version
  locale_id = "en_US"
  
  n_lu_intent_confidence_threshold = 0.40
}

# Lex Bot Intent
resource "aws_lexv2_bot_intent" "order_pizza" {
  bot_id = aws_lexv2_bot.pizza_bot.id
  bot_version = aws_lexv2_bot_version.pizza_bot_version.bot_version
  locale_id = aws_lexv2_bot_locale.pizza_bot_locale.locale_id
  
  intent_name = "OrderPizza"
  
  sample_utterances {
    utterance = "I want to order a pizza"
  }
  
  sample_utterances {
    utterance = "Can I get a pizza"
  }
  
  sample_utterances {
    utterance = "Order pizza"
  }
}

# Allow Lex to invoke Lambda
resource "aws_lambda_permission" "allow_lex" {
  statement_id  = "AllowLexInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pizza_order_processor.function_name
  principal     = "lexv2.amazonaws.com"
  source_arn    = aws_lexv2_bot.pizza_bot.arn
}