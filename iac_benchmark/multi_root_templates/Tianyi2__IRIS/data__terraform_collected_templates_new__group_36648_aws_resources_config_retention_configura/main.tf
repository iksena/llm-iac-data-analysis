resource "aws_config_retention_configuration" "this" {
  region                   = var.region
  retention_period_in_days = var.retention_period_in_days
}