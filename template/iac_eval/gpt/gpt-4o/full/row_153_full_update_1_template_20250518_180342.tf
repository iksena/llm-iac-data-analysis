To create a Lambda event source mapping from a DynamoDB table, we will define a Terraform configuration that sets up the necessary AWS resources. This includes creating a DynamoDB table, a Lambda function, and an event source mapping that triggers the Lambda function whenever there are changes in the DynamoDB table. We will also create the necessary IAM roles and policies to allow the Lambda function to read from the DynamoDB stream.

Here's the Terraform configuration:

1. **AWS Provider**: Configure the AWS provider to deploy resources in a specific region.
2. **DynamoDB Table**: Create a DynamoDB table with a stream enabled.
3. **IAM Role and Policy**: Create an IAM role and policy for the Lambda function to allow it to read from the DynamoDB stream.
4. **Lambda Function**: Define a simple Lambda function.
5. **Event Source Mapping**: Create an event source mapping to connect the DynamoDB stream to the Lambda function.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-dynamodb-role"

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

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-dynamodb-policy"
  description = "Policy for Lambda to access DynamoDB stream"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams"
        ]
        Effect   = "Allow"
        Resource = "${aws_dynamodb_table.example.stream_arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "example" {
  filename         = "lambda_function_payload.zip"
  function_name    = "example_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_dynamodb_table.example.stream_arn
  function_name    = aws_lambda_function.example.arn
  starting_position = "LATEST"
}
```
</iac_template>

This configuration will set up a DynamoDB table with a stream, a Lambda function, and an event source mapping that triggers the Lambda function when there are changes in the DynamoDB table. The IAM role and policy ensure that the Lambda function has the necessary permissions to access the DynamoDB stream.