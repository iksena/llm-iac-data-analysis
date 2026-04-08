resource "aws_api_gateway_integration_response" "this" {
  http_method = var.http_method
  resource_id = var.resource_id
  rest_api_id = var.rest_api_id
  status_code = var.status_code

  region              = var.region
  content_handling    = var.content_handling
  response_parameters = var.response_parameters
  response_templates  = var.response_templates
  selection_pattern   = var.selection_pattern
}