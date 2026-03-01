I'll help you create a Terraform configuration that sets up an AWS EventBridge (CloudWatch Events) rule to trigger a Lambda function daily at 7 UTC. Here's what the configuration will include:

1. AWS Lambda function with a basic Python runtime
2. IAM role and policy for Lambda execution
3. EventBridge rule to schedule the Lambda function
4. IAM role permissions for EventBridge to invoke Lambda
5. Required providers and variables

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Lambda IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "daily_lambda_role"

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

# Lambda Basic Execution Policy
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = <<EOF
def lambda_handler(event, context):
    print("Daily task executed at 7 UTC")
    return {
        'statusCode': 200,
        'body': 'Success'
    }
EOF
    filename = "lambda_function.py"
  }
}

# Lambda Function
resource "aws_lambda_function" "daily_task" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "daily_task_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-task-trigger"
  description         = "Triggers Lambda function daily at 7 UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.daily_task.arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_task.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}
</iac_template>

This Terraform configuration creates:

1. An IAM role for the Lambda function with basic execution permissions
2. A Lambda function with a simple Python handler
3. An EventBridge rule that triggers at 7 UTC daily using a cron expression
4. The necessary permissions for EventBridge to invoke the Lambda function
5. A ZIP archive for the Lambda function code

The Lambda function is basic and just prints a message, but you can modify the Python code in the `lambda_handler` function to perform your required daily tasks.

To deploy this:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

The Lambda function will be triggered automatically every day at 7 UTC.