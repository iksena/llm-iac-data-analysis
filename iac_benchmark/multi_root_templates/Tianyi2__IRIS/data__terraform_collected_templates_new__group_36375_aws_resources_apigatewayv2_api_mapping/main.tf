resource "aws_apigatewayv2_api_mapping" "this" {
  region          = var.region
  api_id          = var.api_id
  domain_name     = var.domain_name
  stage           = var.stage
  api_mapping_key = var.api_mapping_key
}