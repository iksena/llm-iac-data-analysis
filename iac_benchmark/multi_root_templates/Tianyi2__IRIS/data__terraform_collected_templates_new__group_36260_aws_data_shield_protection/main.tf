locals {
  # Validation: Exactly one of protection_id or resource_arn is required
  validation_check = (var.protection_id != null && var.resource_arn == null) || (var.protection_id == null && var.resource_arn != null) ? true : tobool("Exactly one of protection_id or resource_arn is required.")
}

data "aws_shield_protection" "this" {
  protection_id = var.protection_id
  resource_arn  = var.resource_arn
}