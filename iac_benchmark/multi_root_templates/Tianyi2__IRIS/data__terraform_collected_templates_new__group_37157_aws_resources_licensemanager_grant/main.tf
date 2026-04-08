resource "aws_licensemanager_grant" "this" {
  name               = var.name
  allowed_operations = var.allowed_operations
  license_arn        = var.license_arn
  principal          = var.principal
}