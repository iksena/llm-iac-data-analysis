resource "aws_shield_protection" "this" {
  name         = var.name
  resource_arn = var.resource_arn
  tags         = var.tags
}