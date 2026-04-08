resource "aws_verifiedpermissions_policy_store" "this" {
  validation_settings {
    mode = var.validation_mode
  }

  region              = var.region
  deletion_protection = var.deletion_protection
  description         = var.description
  tags                = var.tags
}