I'll create an improved version of the Terraform template for creating an AWS Lex bot with Lambda integration. This version will be more concise and follow proper syntax.

Description:
This Terraform configuration creates:
1. An AWS Lex V2 bot for pizza ordering
2. A Lambda function to process pizza orders
3. Necessary IAM roles and permissions
4. Basic bot configuration with an intent for pizza ordering

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
</iac_template>

This improved version:
1. Uses the correct resource types and attributes
2. Includes proper IAM roles and permissions
3. Provides necessary bot configuration including abort statements and clarification prompts
4. Includes sample utterances for the pizza ordering intent
5. Sets up Lambda integration with the bot

Note: You'll need to create a `lambda_function.zip` file containing your Lambda function code before applying this configuration. The Lambda function should be written to handle the pizza ordering logic and respond to Lex's requests.