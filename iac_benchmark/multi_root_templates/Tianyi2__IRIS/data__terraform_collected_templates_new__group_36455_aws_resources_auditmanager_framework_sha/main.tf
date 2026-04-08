resource "aws_auditmanager_framework_share" "this" {
  destination_account = var.destination_account
  destination_region  = var.destination_region
  framework_id        = var.framework_id
  region              = var.region
  comment             = var.comment
}