<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#########################################################
# IAM Role and Policy for Lambda Execution
#########################################################
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role_for_order_handler"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#########################################################
# Archive File for the Lambda Function Code
#########################################################
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/order_handler.zip"

  source {
    content  = <<EOF
def lambda_handler(event, context):
    # Simple function to respond to pizza orders.
    return {
        "statusCode": 200,
        "body": "Your pizza order has been received!"
    }
EOF
    filename = "order_handler.py"
  }
}

#########################################################
# Create the Lambda Function
#########################################################
resource "aws_lambda_function" "order_handler" {
  function_name    = "order_handler"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "order_handler.lambda_handler"
  runtime          = "python3.8"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_execution]
}

#########################################################
# Allow Lex to Invoke the Lambda Function
#########################################################
resource "aws_lambda_permission" "lex_invoke" {
  statement_id  = "AllowLexInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.order_handler.function_name
  principal     = "lex.amazonaws.com"
}

#########################################################
# Lex Intent for Pizza Ordering
#########################################################
resource "aws_lex_intent" "pizza_order_intent" {
  name              = "PizzaOrderIntent"
  description       = "Intent to order pizzas"
  sample_utterances = [
    "I want to order a pizza",
    "I'd like a pizza",
    "Pizza please"
  ]

  conclusion_statement {
    message {
      content      = "Your pizza order has been placed."
      content_type = "PlainText"
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

#########################################################
# Lex Bot for Ordering Pizzas
#########################################################
resource "aws_lex_bot" "pizza_bot" {
  name                        = "PizzaOrderBot"
  description                 = "Lex bot to order pizzas"
  locale                      = "en-US"
  child_directed              = false
  idle_session_ttl_in_seconds = 300

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I did not understand that. Could you please repeat?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "I'm sorry, I couldn't understand. Please try again later."
      content_type = "PlainText"
    }
  }

  intent {
    intent_name    = aws_lex_intent.pizza_order_intent.name
    intent_version = "$LATEST"
  }

  # Set fulfillment_activity as an argument rather than as a block.
  fulfillment_activity = {
    type      = "CodeHook"
    code_hook = {
      uri             = aws_lambda_function.order_handler.invoke_arn
      message_version = "1.0"
    }
  }

  depends_on = [
    aws_lambda_permission.lex_invoke,
    aws_lambda_function.order_handler
  ]
}
</iac_template>