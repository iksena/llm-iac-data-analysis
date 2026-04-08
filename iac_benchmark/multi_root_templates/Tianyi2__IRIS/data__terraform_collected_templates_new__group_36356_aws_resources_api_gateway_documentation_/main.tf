resource "aws_api_gateway_documentation_version" "this" {
  region      = var.region
  version     = var.doc_version
  rest_api_id = var.rest_api_id
  description = var.description
}