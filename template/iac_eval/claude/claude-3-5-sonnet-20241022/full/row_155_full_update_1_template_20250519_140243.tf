I'll help you create a Terraform configuration that sets up an AWS Lambda function with a CloudWatch Event Rule (EventBridge) to trigger it every 15 minutes. The configuration will include:

1. An IAM role for the Lambda function with basic execution permissions
2. A Lambda function with a simple Python code
3. A CloudWatch Event Rule to trigger the Lambda function every 15 minutes
4. The necessary IAM permissions for CloudWatch to invoke the Lambda function

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "scheduled_lambda_role"

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

# Attach basic Lambda execution policy to the role
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
    print("Lambda function executed")
    return {
        'statusCode': 200,
        'body': 'Function executed successfully'
    }
EOF
    filename = "lambda_function.py"
  }
}

# Create Lambda function
resource "aws_lambda_function" "scheduled_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "scheduled_lambda_function"
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

# Create CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "every_fifteen_minutes" {
  name                = "every-fifteen-minutes"
  description         = "Triggers every fifteen minutes"
  schedule_expression = "rate(15 minutes)"
}

# Set Lambda function as target for the CloudWatch Event Rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_fifteen_minutes.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.scheduled_lambda.arn
}

# Add permission for CloudWatch to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_fifteen_minutes.arn
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role with basic Lambda execution permissions
3. A simple Python Lambda function that prints a message and returns a success response
4. A CloudWatch Event Rule that triggers every 15 minutes
5. The necessary permissions for CloudWatch to invoke the Lambda function
6. A ZIP archive of the Lambda function code

The Lambda function will be triggered automatically every 15 minutes after deployment. The function is basic but can be modified by updating the Python code in the `lambda_function.py` content section.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the changes: `terraform plan`
3. Apply the configuration: `terraform apply`

The Lambda function will start executing every 15 minutes once deployed.