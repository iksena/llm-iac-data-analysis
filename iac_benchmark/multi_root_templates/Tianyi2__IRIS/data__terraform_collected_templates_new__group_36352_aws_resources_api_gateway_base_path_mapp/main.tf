resource "aws_api_gateway_base_path_mapping" "this" {
  region         = var.region
  domain_name    = var.domain_name
  api_id         = var.api_id
  stage_name     = var.stage_name
  base_path      = var.base_path
  domain_name_id = var.domain_name_id
}