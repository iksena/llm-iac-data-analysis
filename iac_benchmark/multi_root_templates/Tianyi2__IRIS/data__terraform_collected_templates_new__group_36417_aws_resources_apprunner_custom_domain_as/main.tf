resource "aws_apprunner_custom_domain_association" "this" {
  region               = var.region
  domain_name          = var.domain_name
  enable_www_subdomain = var.enable_www_subdomain
  service_arn          = var.service_arn
}