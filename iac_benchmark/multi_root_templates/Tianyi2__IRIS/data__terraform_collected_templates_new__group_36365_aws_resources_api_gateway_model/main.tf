resource "aws_api_gateway_model" "this" {
  region       = var.region
  rest_api_id  = var.rest_api_id
  name         = var.name
  description  = var.description
  content_type = var.content_type
  schema       = var.schema
}