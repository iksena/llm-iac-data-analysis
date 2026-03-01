To build and deploy the described AWS infrastructure using Terraform, we will create the following resources:

1. **AWS S3 Bucket**: This will store the cat pictures uploaded by users.
2. **AWS DynamoDB Table**: This will store metadata about the cat pictures, such as their S3 object keys.
3. **AWS Lambda Function**: This function will handle the logic for uploading and retrieving cat pictures. It will interact with both the S3 bucket and the DynamoDB table.
4. **AWS API Gateway**: This will provide a RESTful API interface for users to interact with the Lambda function. It will have resources and methods to handle HTTP requests.
5. **AWS IAM Roles and Policies**: These will provide the necessary permissions for the Lambda function to access the S3 bucket and DynamoDB table.

Below is the complete Terraform HCL configuration for this setup:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cat_pictures" {
  bucket = "cat-pictures-bucket-123456"
  acl    = "private"
}

resource "aws_dynamodb_table" "cat_metadata" {
  name           = "CatMetadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PictureId"

  attribute {
    name = "PictureId"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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
  name        = "lambda_policy"
  description = "Policy for Lambda to access S3 and DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.cat_pictures.arn}/*"
      },
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.cat_metadata.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "cat_function" {
  filename         = "lambda_function_payload.zip"
  function_name    = "CatFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_api_gateway_rest_api" "cat_api" {
  name        = "CatAPI"
  description = "API for uploading and retrieving cat pictures"
}

resource "aws_api_gateway_resource" "cat_resource" {
  rest_api_id = aws_api_gateway_rest_api.cat_api.id
  parent_id   = aws_api_gateway_rest_api.cat_api.root_resource_id
  path_part   = "cats"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.cat_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.cat_api.id
  resource_id   = aws_api_gateway_resource.cat_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cat_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.cat_api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cat_api.id
  resource_id             = aws_api_gateway_resource.cat_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cat_function.invoke_arn
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cat_api.id
  resource_id             = aws_api_gateway_resource.cat_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cat_function.invoke_arn
}

output "api_endpoint" {
  value = aws_api_gateway_rest_api.cat_api.execution_arn
}
```
</iac_template>

This configuration sets up the necessary AWS resources to support a web service for uploading and retrieving cat pictures. The Lambda function will need to be implemented with the appropriate logic to handle these operations, and the `lambda_function_payload.zip` should contain the deployment package for the Lambda function.