resource "aws_verifiedaccess_instance" "this" {
  region                          = var.region
  description                     = var.description
  fips_enabled                    = var.fips_enabled
  cidr_endpoints_custom_subdomain = var.cidr_endpoints_custom_subdomain
  tags                            = var.tags
}