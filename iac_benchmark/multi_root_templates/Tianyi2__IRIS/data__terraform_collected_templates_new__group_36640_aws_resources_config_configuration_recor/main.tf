resource "aws_config_configuration_recorder_status" "this" {
  name       = var.name
  is_enabled = var.is_enabled
  region     = var.region
}