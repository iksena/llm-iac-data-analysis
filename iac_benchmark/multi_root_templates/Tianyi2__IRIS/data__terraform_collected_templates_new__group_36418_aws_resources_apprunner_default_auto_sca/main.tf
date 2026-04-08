resource "aws_apprunner_default_auto_scaling_configuration_version" "this" {
  region                         = var.region
  auto_scaling_configuration_arn = var.auto_scaling_configuration_arn
}