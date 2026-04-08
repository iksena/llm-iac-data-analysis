resource "aws_shield_application_layer_automatic_response" "this" {
  resource_arn = var.resource_arn
  action       = var.action
}