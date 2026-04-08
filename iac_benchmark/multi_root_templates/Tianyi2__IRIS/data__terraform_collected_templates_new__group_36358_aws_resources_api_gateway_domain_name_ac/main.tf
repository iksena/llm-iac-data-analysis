resource "aws_api_gateway_domain_name_access_association" "this" {
  region                         = var.region
  access_association_source      = var.access_association_source
  access_association_source_type = var.access_association_source_type
  domain_name_arn                = var.domain_name_arn
  tags                           = var.tags
}