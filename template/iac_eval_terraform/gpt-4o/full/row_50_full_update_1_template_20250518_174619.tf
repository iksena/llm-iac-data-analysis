To create an AWS Lex bot for ordering pizzas, we will define a Terraform configuration that sets up an AWS Lex bot with intents and slots necessary for ordering pizzas. Additionally, we will create an AWS Lambda function that can be used to fulfill the intent of ordering a pizza. The Lambda function will be triggered by the Lex bot to process the order. We will also set up the necessary IAM roles and policies to allow the Lex bot and Lambda function to interact securely.

The configuration will include:
1. An AWS Lex bot with intents for ordering pizzas.
2. An AWS Lambda function to handle the fulfillment of the pizza order.
3. IAM roles and policies to allow the Lex bot to invoke the Lambda function.

The configuration will be deployed in the `us-east-1` region.

<iac_template>
```hcl
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
```
</iac_template>