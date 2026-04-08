resource "aws_apprunner_deployment" "this" {
  region      = var.region
  service_arn = var.service_arn
}