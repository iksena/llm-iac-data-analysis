data "aws_auditmanager_framework" "this" {
  region         = var.region
  name           = var.name
  framework_type = var.type
}