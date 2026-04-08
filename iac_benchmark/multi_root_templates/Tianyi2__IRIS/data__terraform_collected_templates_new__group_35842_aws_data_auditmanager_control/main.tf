data "aws_auditmanager_control" "this" {
  region = var.region
  name   = var.name
  type   = var.type
}