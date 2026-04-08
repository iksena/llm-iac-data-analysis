resource "aws_apigatewayv2_authorizer" "auth" {
  count = var.enable_cognito_authorizer ? 1 : 0

  api_id           = aws_apigatewayv2_api.api-gw.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"
  authorizer_result_ttl_in_seconds = 0

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = "https://cognito-idp.${var.cognito_region}.amazonaws.com/${var.cognito_user_pool_id}"
  }
}