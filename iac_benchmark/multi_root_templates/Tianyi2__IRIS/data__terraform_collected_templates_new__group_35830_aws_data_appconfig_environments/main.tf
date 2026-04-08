data "aws_appconfig_environments" "this" {
  application_id = var.application_id
  region         = var.region
}