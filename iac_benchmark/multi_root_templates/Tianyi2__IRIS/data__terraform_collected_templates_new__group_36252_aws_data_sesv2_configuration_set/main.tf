data "aws_sesv2_configuration_set" "this" {
  region                 = var.region
  configuration_set_name = var.configuration_set_name
}