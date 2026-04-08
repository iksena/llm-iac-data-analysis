data "aws_securityhub_standards_control_associations" "this" {
  region              = var.region
  security_control_id = var.security_control_id
}