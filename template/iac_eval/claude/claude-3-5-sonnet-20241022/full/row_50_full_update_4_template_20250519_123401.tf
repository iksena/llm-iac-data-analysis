I'll create a corrected version that includes the required intent block for the Lex bot.

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

  environment {
    variables = {
      PIZZA_STORE_NAME = "TerraformPizza"
    }
  }
}

# Lex Intent
resource "aws_lex_intent" "order_pizza" {
  name = "OrderPizza"
  
  fulfillment_activity {
    type = "ReturnIntent"
  }

  sample_utterances = [
    "I want to order a pizza",
    "Can I get a pizza",
    "Order pizza"
  ]
}

# Lex Bot
resource "aws_lex_bot" "pizza_bot" {
  name        = "PizzaOrderingBot"
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
    intent_name    = aws_lex_intent.order_pizza.name
    intent_version = "$LATEST"
  }

  child_directed = false

  idle_session_ttl_in_seconds = 300
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

The main changes made to fix the syntax errors:
1. Added the required `aws_lex_intent` resource to define the pizza ordering intent
2. Added the required `intent` block within the `aws_lex_bot` resource, referencing the created intent
3. Set the intent version to "$LATEST"
4. Simplified the intent configuration to use "ReturnIntent" as the fulfillment activity type

This template should now properly create a Lex bot with the required intent configuration for pizza ordering, along with the associated Lambda function for processing orders.