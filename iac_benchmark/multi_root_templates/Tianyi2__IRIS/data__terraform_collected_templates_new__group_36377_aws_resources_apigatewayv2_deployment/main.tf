resource "aws_apigatewayv2_deployment" "this" {
  region      = var.region
  api_id      = var.api_id
  description = var.description
  triggers    = var.triggers

  lifecycle {
    create_before_destroy = true
  }
}