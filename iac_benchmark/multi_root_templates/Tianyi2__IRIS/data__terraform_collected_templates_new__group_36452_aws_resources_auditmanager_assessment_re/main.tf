resource "aws_auditmanager_assessment_report" "this" {
  name          = var.name
  assessment_id = var.assessment_id
  region        = var.region
  description   = var.description
}