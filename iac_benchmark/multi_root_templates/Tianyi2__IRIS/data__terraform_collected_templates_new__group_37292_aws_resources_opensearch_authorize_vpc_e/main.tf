resource "aws_opensearch_authorize_vpc_endpoint_access" "this" {
  region      = var.region
  account     = var.account
  domain_name = var.domain_name
}