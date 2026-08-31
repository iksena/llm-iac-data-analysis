resource "random_pet" "lambda_bucket_name" {
  prefix = "demo"
  length = 4
}

###################
# S3 Bucket for Lambda
###################
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}


resource "aws_s3_object" "lambda_worker" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "deploy.zip"
  source = data.archive_file.lambda_worker.output_path
  etag = filemd5(data.archive_file.lambda_worker.output_path)
}

###################
# Create Role for Lambda
###################
resource "aws_iam_role" "lambda_role" {
  name = "api-lambda-role"
  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  )
}

resource "aws_iam_policy" "lambda_policy" {
  name ="${aws_iam_role.lambda_role.name}-policy"
  description  = "IAM policy for a lambda"
  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams",
              "logs:PutLogEvents",
              "logs:GetLogEvents",
              "logs:FilterLogEvents"
          ],
          "Resource": "*"
      }
    ]
  }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role        = aws_iam_role.lambda_role.id
  policy_arn  = aws_iam_policy.lambda_policy.id
}

###################
# Create Lambda Function
###################
resource "aws_lambda_function" "demo_lambda" {
  function_name = "api-backend-demo"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_worker.key

  handler       = "main.lambda_handler"
  runtime       = "python3.7"

  source_code_hash = data.archive_file.lambda_worker.output_base64sha256
  role = aws_iam_role.lambda_role.arn
}

###################
# Create API Gateway
###################
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  integration_uri    = aws_lambda_function.demo_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda_route_root" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route1" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  route_key = "GET /person"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.api_authorizer.id
}

resource "aws_apigatewayv2_route" "lambda_route2" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  route_key = "POST /person"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.api_authorizer.id
}

resource "aws_apigatewayv2_route" "lambda_route3" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  route_key = "DELETE /person"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.api_authorizer.id
}

resource "aws_apigatewayv2_route" "lambda_route4" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  route_key = "PUT /person"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.api_authorizer.id
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_api.name}"

  retention_in_days = 1
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}


resource "aws_apigatewayv2_authorizer" "api_authorizer" {
  api_id           = aws_apigatewayv2_api.lambda_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "api-authorizer"

  jwt_configuration {
    audience = ["${aws_cognito_user_pool_client.client.id}"]
    issuer   = "https://${aws_cognito_user_pool.user_pool.endpoint}"
  }
}

###################
# Create Cognito
###################
resource "aws_cognito_user_pool" "user_pool" {
  name = "demo-app-user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account need to be confirmed"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "demo-app-cognito-client"

  user_pool_id                          = aws_cognito_user_pool.user_pool.id
  generate_secret                       = true
  refresh_token_validity                = 90
  allowed_oauth_flows                   = ["code","implicit"]
  allowed_oauth_scopes                  = ["phone","email","openid","profile","aws.cognito.signin.user.admin"]   
  allowed_oauth_flows_user_pool_client  = true
  prevent_user_existence_errors         = "ENABLED"
  callback_urls                         = [var.callback_urls]
  logout_urls                           = [var.logout_urls]
  explicit_auth_flows                   = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
  
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = var.domain_prefix
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}



