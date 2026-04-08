resource "aws_pinpoint_email_channel" "this" {
  region                         = var.region
  application_id                 = var.application_id
  enabled                        = var.enabled
  configuration_set              = var.configuration_set
  from_address                   = var.from_address
  identity                       = var.identity
  orchestration_sending_role_arn = var.orchestration_sending_role_arn
  role_arn                       = var.role_arn
}