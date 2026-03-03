I'll help you create a Terraform configuration for an Amazon Lex bot that handles pizza orders, integrated with a Lambda function for order processing. The bot will be able to handle basic pizza ordering interactions, and the Lambda function will process the order details.

Description:
This Terraform configuration will create:
1. An AWS Lex Bot V2 for pizza ordering with intents and slot types
2. A Lambda function to process the pizza orders
3. IAM roles and policies for both Lex and Lambda
4. Necessary permissions for Lex to invoke the Lambda function

Here's the complete Terraform configuration:

<iac_template>
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
</iac_template>

Note: This configuration creates a basic Lex bot with a simple intent for pizza ordering. You'll need to:

1. Create a zip file containing your Lambda function code (lambda_function.zip)
2. Further customize the bot with additional intents, slot types, and utterances based on your specific requirements
3. The Lambda function should be implemented to handle the pizza order processing logic
4. You might want to add more sample utterances and slot types for pizza size, toppings, etc.

The configuration includes:
- Basic IAM roles and permissions for both Lex and Lambda
- A Lambda function for processing orders
- A Lex bot with English locale
- A basic intent for pizza ordering
- Necessary permissions for Lex to invoke the Lambda function

You can enhance this further by adding more intents, slot types, and utterances to make the bot more sophisticated in handling pizza orders.