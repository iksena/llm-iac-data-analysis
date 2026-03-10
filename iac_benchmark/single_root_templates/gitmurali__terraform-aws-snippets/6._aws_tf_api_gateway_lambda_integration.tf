# ── variables.tf ────────────────────────────────────
variable "AWS_REGION" {
  default   = "us-east-1"
  type      = string
  sensitive = true
}

variable "AWS_ACCOUNT_ID" {
  default   = "Your aws account number"
  type      = string
  sensitive = true
}

# ── API-GW.tf ────────────────────────────────────
resource "aws_api_gateway_rest_api" "API" {
  name        = "lambda-api"
  description = "lambda-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "Resource" {
  rest_api_id = aws_api_gateway_rest_api.API.id
  parent_id   = aws_api_gateway_rest_api.API.root_resource_id
  path_part   = "verify-json"
}

resource "aws_api_gateway_method" "Method" {
  rest_api_id   = aws_api_gateway_rest_api.API.id
  resource_id   = aws_api_gateway_resource.Resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "Integration" {
  rest_api_id             = aws_api_gateway_rest_api.API.id
  resource_id             = aws_api_gateway_resource.Resource.id
  http_method             = aws_api_gateway_method.Method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda-function.invoke_arn
}


resource "aws_lambda_permission" "apigw-lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.API.id}/*/${aws_api_gateway_method.Method.http_method}${aws_api_gateway_resource.Resource.path}"
}



resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.API.id
  resource_id = aws_api_gateway_resource.Resource.id
  http_method = aws_api_gateway_method.Method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "Integration-Response" {
  rest_api_id = aws_api_gateway_rest_api.API.id
  resource_id = aws_api_gateway_resource.Resource.id
  http_method = aws_api_gateway_method.Method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  depends_on = [
    aws_api_gateway_integration.Integration
  ]

  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}


resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.Integration
  ]
  rest_api_id = aws_api_gateway_rest_api.API.id
  stage_name  = "test"
}

# ── iam-policy.tf ────────────────────────────────────
resource "aws_iam_role_policy" "iam-policy" {
  name   = "cloudwatch-policy"
  role   = aws_iam_role.iam-role.id
  policy = file("${path.module}/iam-policy.json")
}

# ── iam-role.tf ────────────────────────────────────
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam-role" {
  name               = "iam-role-lambda-api-gateway"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# ── lambda-function.tf ────────────────────────────────────
resource "aws_lambda_function" "lambda-function" {
  filename      = "${path.module}/code.zip"
  function_name = "api-gw-lambda"
  role          = aws_iam_role.iam-role.arn
  handler       = "code.lambda_handler"
  runtime       = "python3.9"
}

# ── output.tf ────────────────────────────────────
output "api-gateway-url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

# ── provider.tf ────────────────────────────────────
provider "aws" {
  region = "us-east-1"
}