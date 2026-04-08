resource "aws_apigatewayv2_integration" "lambda-integration" {
  count = var.integration_type == "lambda" ? 1 : 0

  api_id = var.apigw_id
  integration_type      = "AWS_PROXY"
  connection_type       = "INTERNET"
  description           = "Lambda ${var.lambda_arn} integration"
  integration_method    = "POST"
  integration_uri       = var.lambda_arn
  passthrough_behavior  = "WHEN_NO_MATCH"
}