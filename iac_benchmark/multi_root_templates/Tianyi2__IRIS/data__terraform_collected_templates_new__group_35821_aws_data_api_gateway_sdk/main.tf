data "aws_api_gateway_sdk" "this" {
  region      = var.region
  rest_api_id = var.rest_api_id
  stage_name  = var.stage_name
  sdk_type    = var.sdk_type
  parameters  = var.parameters
}