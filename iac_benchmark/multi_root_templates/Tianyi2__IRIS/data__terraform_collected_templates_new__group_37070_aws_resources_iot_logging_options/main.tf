resource "aws_iot_logging_options" "this" {
  region            = var.region
  default_log_level = var.default_log_level
  disable_all_logs  = var.disable_all_logs
  role_arn          = var.role_arn
}