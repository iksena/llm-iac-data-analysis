data "aws_api_gateway_domain_name" "this" {
  region         = var.region
  domain_name    = var.domain_name
  domain_name_id = var.domain_name_id
}