resource "aws_appsync_domain_name" "this" {
  region          = var.region
  certificate_arn = var.certificate_arn
  description     = var.description
  domain_name     = var.domain_name
}