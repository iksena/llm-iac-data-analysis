data "aws_elasticsearch_domain" "this" {
  domain_name = var.domain_name
  region      = var.region
}