Below is a description of the Terraform configuration followed by the complete HCL code inside <iac_template> tags.

Description:
• The provider is configured for AWS in the us-east-1 region.
• An IAM role (with its policy attachment) is created for the Lambda function. The role’s assume policy allows the lambda.amazonaws.com service.
• A simple Python Lambda function is defined that returns a static response. Its source code is packaged using the archive_file data source.
• An AWS Lambda function (order_handler) is created with the inline zipped code.
• A Lambda permission is granted to Lex (principal "lex.amazonaws.com") so that the Lex bot can call the Lambda function.
• An AWS Lex intent (PizzaOrderIntent) is defined with sample utterances and a simple conclusion statement.
• Finally, an AWS Lex bot (PizzaOrderBot) is defined for ordering pizzas. The bot lists the PizzaOrderIntent in its intents block and is configured with a fulfillment_activity that calls the Lambda function via a CodeHook.

Below is the complete Terraform configuration:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

##############################################
# IAM Role and Policy for Lambda Execution
##############################################
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role_for_order_handler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

##############################################
# Archive file for the Lambda function code
##############################################
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/order_handler.zip"
  source {
    content  = <<EOF
def lambda_handler(event, context):
    # Simple function to respond to pizza orders.
    return {
        'statusCode': 200,
        'body': 'Your pizza order has been received!'
    }
EOF
    filename = "order_handler.py"
  }
}

##############################################
# Create the Lambda function
##############################################
resource "aws_lambda_function" "order_handler" {
  function_name = "order_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "order_handler.lambda_handler"
  runtime       = "python3.8"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

##############################################
# Allow Lex to invoke the Lambda function
##############################################
resource "aws_lambda_permission" "lex_invoke" {
  statement_id  = "AllowLexInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.order_handler.function_name
  principal     = "lex.amazonaws.com"
}

##############################################
# Lex Intent for Pizza Ordering
##############################################
resource "aws_lex_intent" "pizza_order_intent" {
  name        = "PizzaOrderIntent"
  description = "Intent to order pizzas"
  sample_utterances = [
    "I want to order a pizza",
    "I'd like a pizza",
    "Pizza please"
  ]
  
  conclusion_statement {
    messages {
      content      = "Your pizza order has been placed."
      content_type = "PlainText"
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

##############################################
# Lex Bot for Ordering Pizzas
##############################################
resource "aws_lex_bot" "pizza_bot" {
  name                         = "PizzaOrderBot"
  description                  = "Lex bot to order pizzas"
  locale                       = "en-US"
  child_directed               = false
  idle_session_ttl_in_seconds  = 300

  clarification_prompt {
    max_attempts = 2
    messages {
      content      = "I did not understand that. Could you please repeat?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    messages {
      content      = "I'm sorry, I couldn't understand. Please try again later."
      content_type = "PlainText"
    }
  }

  intents {
    intent_name    = aws_lex_intent.pizza_order_intent.name
    intent_version = "$LATEST"
  }

  fulfillment_activity {
    type = "CodeHook"
    code_hook {
      uri             = aws_lambda_function.order_handler.invoke_arn
      message_version = "1.0"
    }
  }
}
</iac_template>