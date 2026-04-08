resource "aws_redshiftserverless_custom_domain_association" "this" {
  workgroup_name                = var.workgroup_name
  custom_domain_name            = var.custom_domain_name
  custom_domain_certificate_arn = var.custom_domain_certificate_arn
  region                        = var.region
}