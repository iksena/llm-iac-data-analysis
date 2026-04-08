data "aws_api_gateway_authorizer" "this" {
  region        = var.region
  authorizer_id = var.authorizer_id
  rest_api_id   = var.rest_api_id
}