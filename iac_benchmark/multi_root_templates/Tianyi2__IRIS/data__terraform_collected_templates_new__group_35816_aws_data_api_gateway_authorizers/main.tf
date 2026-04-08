data "aws_api_gateway_authorizers" "this" {
  region      = var.region
  rest_api_id = var.rest_api_id
}