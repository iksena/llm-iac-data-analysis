data "aws_api_gateway_resource" "this" {
  region      = var.region
  rest_api_id = var.rest_api_id
  path        = var.path
}