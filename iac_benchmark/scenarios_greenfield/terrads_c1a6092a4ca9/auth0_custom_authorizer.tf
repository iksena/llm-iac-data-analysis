resource "aws_api_gateway_authorizer" "rest_authorizer" {
  for_each = { for custom_authorizer in var.custom_authorizers : custom_authorizer.name => custom_authorizer if var.api_type == "rest" }

  name                   = each.value.name
  rest_api_id            = aws_api_gateway_rest_api.rest_api[0].id
  authorizer_uri         = aws_lambda_function.authorizer[each.value.name].invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role[each.value.name].arn
}

resource "aws_iam_role" "invocation_role" {
  for_each           = { for custom_authorizer in var.custom_authorizers : custom_authorizer.name => custom_authorizer if var.api_type == "rest" }
  name               = "api_gateway_auth_invocation-${each.value.name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com",
                    "apigateway.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "invocation_policy" {
  for_each = { for custom_authorizer in var.custom_authorizers : custom_authorizer.name => custom_authorizer if var.api_type == "rest" }
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.authorizer[each.value.name].arn]
  }
}

resource "aws_iam_role_policy" "invocation_policy" {
  for_each = { for custom_authorizer in var.custom_authorizers : custom_authorizer.name => custom_authorizer if var.api_type == "rest" }
  name     = "auth-custom-authorizer-${each.value.name}-policy"
  role     = aws_iam_role.invocation_role[each.value.name].id
  policy   = data.aws_iam_policy_document.invocation_policy[each.value.name].json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  for_each           = { for custom_authorizer in var.custom_authorizers : custom_authorizer.name => custom_authorizer if var.api_type == "rest" }
  name               = "custom-authorizer-lambda-${each.value.name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_lambda_function" "authorizer" {
  for_each         = { for custom_authorizer in var.custom_authorizers : custom_authorizer.name => custom_authorizer if var.api_type == "rest" }
  filename         = each.value.custom_authorizer_lambda_code
  function_name    = "api_gateway_authorizer-${each.value.name}-lambda"
  role             = aws_iam_role.lambda[each.value.name].arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256(each.value.custom_authorizer_lambda_code)
  runtime          = "nodejs16.x"

  environment {
    variables = {
      AUDIENCE = ""
      JWKS_URI = ""
    }
  }
}