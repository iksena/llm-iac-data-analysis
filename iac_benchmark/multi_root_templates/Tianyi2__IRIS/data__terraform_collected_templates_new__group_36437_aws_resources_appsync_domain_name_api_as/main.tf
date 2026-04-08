resource "aws_appsync_domain_name_api_association" "this" {
  region      = var.region
  api_id      = var.api_id
  domain_name = var.domain_name
}