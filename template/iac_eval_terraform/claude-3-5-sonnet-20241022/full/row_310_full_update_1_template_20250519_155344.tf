I'll help you create a Terraform configuration that sets up an AWS EventBridge (CloudWatch Events) rule to trigger a Lambda function daily at 7 UTC. This configuration will include:

1. An AWS Lambda function with basic Python code
2. IAM role and policy for the Lambda function
3. EventBridge rule to schedule the Lambda execution
4. Lambda permission to allow EventBridge to invoke it

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
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

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = <<EOF
def lambda_handler(event, context):
    print("Daily task executed at 7 UTC")
    return {
        'statusCode': 200,
        'body': 'Daily task completed successfully'
    }
EOF
    filename = "lambda_function.py"
  }
}

# Create Lambda function
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

# Create EventBridge rule
resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-task-trigger"
  description         = "Triggers Lambda function daily at 7 UTC"
  schedule_expression = "cron(0 7 * * ? *)"
}

# Set Lambda function as target for the EventBridge rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "DailyLambdaFunction"
  arn       = aws_lambda_function.daily_task.arn
}

# Add permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_task.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}
</iac_template>

This Terraform configuration creates:

1. An IAM role with basic Lambda execution permissions
2. A Lambda function with a simple Python handler
3. An EventBridge rule that triggers at 7 UTC daily using a cron expression
4. The necessary permissions for EventBridge to invoke the Lambda function

The Lambda function is very basic and just prints a message, but you can modify the Python code in the `lambda_handler` function to perform any required task.

To deploy this:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

The Lambda function will be triggered automatically every day at 7 UTC once deployed.