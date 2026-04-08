resource "aws_securityhub_standards_control_association" "this" {
  association_status  = var.association_status
  security_control_id = var.security_control_id
  standards_arn       = var.standards_arn
  region              = var.region
  updated_reason      = var.updated_reason
}