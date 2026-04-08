resource "aws_api_gateway_resource" "this" {
  region      = var.region
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = var.path_part
}