resource "aws_ram_resource_share" "this" {
  region                    = var.region
  name                      = var.name
  allow_external_principals = var.allow_external_principals
  permission_arns           = var.permission_arns
  tags                      = var.tags
}