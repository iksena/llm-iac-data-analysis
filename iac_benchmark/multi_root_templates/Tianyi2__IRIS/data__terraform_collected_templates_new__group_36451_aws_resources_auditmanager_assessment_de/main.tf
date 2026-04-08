resource "aws_auditmanager_assessment_delegation" "this" {
  assessment_id  = var.assessment_id
  control_set_id = var.control_set_id
  role_arn       = var.role_arn
  role_type      = var.role_type

  region  = var.region
  comment = var.comment
}