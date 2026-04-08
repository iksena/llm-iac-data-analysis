resource "aws_securityhub_action_target" "this" {
  region      = var.region
  name        = var.name
  identifier  = var.identifier
  description = var.description
}