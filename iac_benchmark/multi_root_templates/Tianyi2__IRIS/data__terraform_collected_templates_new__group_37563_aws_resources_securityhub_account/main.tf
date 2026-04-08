resource "aws_securityhub_account" "this" {
  region                    = var.region
  enable_default_standards  = var.enable_default_standards
  control_finding_generator = var.control_finding_generator
  auto_enable_controls      = var.auto_enable_controls
}