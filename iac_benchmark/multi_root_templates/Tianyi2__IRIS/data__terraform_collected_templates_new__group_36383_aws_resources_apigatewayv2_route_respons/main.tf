resource "aws_apigatewayv2_route_response" "this" {
  region                     = var.region
  api_id                     = var.api_id
  route_id                   = var.route_id
  route_response_key         = var.route_response_key
  model_selection_expression = var.model_selection_expression
  response_models            = var.response_models
}