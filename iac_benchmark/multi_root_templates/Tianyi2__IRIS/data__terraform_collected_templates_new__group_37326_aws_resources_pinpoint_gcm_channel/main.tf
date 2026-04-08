resource "aws_pinpoint_gcm_channel" "this" {
  application_id                = var.application_id
  api_key                       = var.api_key
  default_authentication_method = var.default_authentication_method
  service_json                  = var.service_json
  enabled                       = var.enabled
}