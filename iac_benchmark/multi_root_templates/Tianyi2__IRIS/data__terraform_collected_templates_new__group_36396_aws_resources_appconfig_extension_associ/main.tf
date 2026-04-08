resource "aws_appconfig_extension_association" "this" {
  region        = var.region
  extension_arn = var.extension_arn
  resource_arn  = var.resource_arn
  parameters    = var.parameters
}