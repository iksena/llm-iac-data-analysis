resource "aws_apigatewayv2_route" "this" {
  region                              = var.region
  api_id                              = var.api_id
  route_key                           = var.route_key
  api_key_required                    = var.api_key_required
  authorization_scopes                = var.authorization_scopes
  authorization_type                  = var.authorization_type
  authorizer_id                       = var.authorizer_id
  model_selection_expression          = var.model_selection_expression
  operation_name                      = var.operation_name
  request_models                      = var.request_models
  route_response_selection_expression = var.route_response_selection_expression
  target                              = var.target

  dynamic "request_parameter" {
    for_each = var.request_parameter
    content {
      request_parameter_key = request_parameter.value.request_parameter_key
      required              = request_parameter.value.required
    }
  }
}