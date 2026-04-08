resource "aws_route53recoveryreadiness_recovery_group" "this" {
  recovery_group_name = var.recovery_group_name
  cells               = var.cells
  tags                = var.tags

  timeouts {
    delete = var.delete_timeout
  }
}