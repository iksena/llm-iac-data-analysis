resource "aws_elasticsearch_domain_policy" "this" {
  region          = var.region
  domain_name     = var.domain_name
  access_policies = var.access_policies
}