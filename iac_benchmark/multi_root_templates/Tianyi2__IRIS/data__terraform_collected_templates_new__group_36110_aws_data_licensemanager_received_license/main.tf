data "aws_licensemanager_received_license" "this" {
  region      = var.region
  license_arn = var.license_arn
}