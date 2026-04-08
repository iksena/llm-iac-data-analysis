resource "aws_api_gateway_deployment" "this" {
  region      = var.region
  description = var.description
  rest_api_id = var.rest_api_id
  triggers    = var.triggers
  variables   = var.variables
}