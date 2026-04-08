resource "aws_pinpoint_baidu_channel" "this" {
  application_id = var.application_id
  api_key        = var.api_key
  secret_key     = var.secret_key
  enabled        = var.enabled
}