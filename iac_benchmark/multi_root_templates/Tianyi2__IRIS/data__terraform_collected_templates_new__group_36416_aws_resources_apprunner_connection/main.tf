resource "aws_apprunner_connection" "this" {
  region          = var.region
  connection_name = var.connection_name
  provider_type   = var.provider_type
  tags            = var.tags
}