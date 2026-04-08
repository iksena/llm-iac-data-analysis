resource "aws_appconfig_application" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags
}