resource "aws_macie2_organization_configuration" "this" {
  region      = var.region
  auto_enable = var.auto_enable
}