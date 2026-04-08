resource "aws_licensemanager_license_configuration" "this" {
  region                   = var.region
  name                     = var.name
  description              = var.description
  license_count            = var.license_count
  license_count_hard_limit = var.license_count_hard_limit
  license_counting_type    = var.license_counting_type
  license_rules            = var.license_rules
  tags                     = var.tags
}