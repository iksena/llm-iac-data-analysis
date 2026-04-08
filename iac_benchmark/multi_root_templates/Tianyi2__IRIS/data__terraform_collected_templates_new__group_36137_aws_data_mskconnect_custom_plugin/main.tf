data "aws_mskconnect_custom_plugin" "this" {
  name   = var.name
  region = var.region
}