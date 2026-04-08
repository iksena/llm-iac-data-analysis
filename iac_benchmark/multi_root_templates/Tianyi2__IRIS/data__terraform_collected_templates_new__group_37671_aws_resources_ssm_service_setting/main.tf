resource "aws_ssm_service_setting" "this" {
  region        = var.region
  setting_id    = var.setting_id
  setting_value = var.setting_value
}