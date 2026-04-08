resource "aws_emr_security_configuration" "this" {
  region        = var.region
  name          = var.name
  name_prefix   = var.name_prefix
  configuration = var.configuration
}