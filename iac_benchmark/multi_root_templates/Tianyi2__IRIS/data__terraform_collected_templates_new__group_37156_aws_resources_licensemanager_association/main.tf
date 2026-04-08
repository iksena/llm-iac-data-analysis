resource "aws_licensemanager_association" "this" {
  region                    = var.region
  license_configuration_arn = var.license_configuration_arn
  resource_arn              = var.resource_arn
}