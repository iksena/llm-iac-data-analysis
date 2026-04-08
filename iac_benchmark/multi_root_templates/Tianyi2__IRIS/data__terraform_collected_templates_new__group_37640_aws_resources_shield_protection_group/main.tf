resource "aws_shield_protection_group" "this" {
  aggregation         = var.aggregation
  members             = var.members
  pattern             = var.pattern
  protection_group_id = var.protection_group_id
  resource_type       = var.resource_type
  tags                = var.tags
}