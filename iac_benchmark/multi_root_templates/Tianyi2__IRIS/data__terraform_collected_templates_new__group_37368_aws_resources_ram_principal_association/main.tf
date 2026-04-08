resource "aws_ram_principal_association" "this" {
  region             = var.region
  principal          = var.principal
  resource_share_arn = var.resource_share_arn
}