resource "aws_api_gateway_documentation_part" "this" {
  location {
    type        = var.location_type
    method      = var.location_method
    name        = var.location_name
    path        = var.location_path
    status_code = var.location_status_code
  }

  properties  = var.properties
  rest_api_id = var.rest_api_id
}