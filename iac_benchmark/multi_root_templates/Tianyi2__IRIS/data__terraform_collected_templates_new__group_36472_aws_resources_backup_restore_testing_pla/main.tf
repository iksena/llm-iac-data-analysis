resource "aws_backup_restore_testing_plan" "this" {
  name                         = var.name
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone
  start_window_hours           = var.start_window_hours

  recovery_point_selection {
    algorithm             = var.recovery_point_selection.algorithm
    include_vaults        = var.recovery_point_selection.include_vaults
    recovery_point_types  = var.recovery_point_selection.recovery_point_types
    exclude_vaults        = var.recovery_point_selection.exclude_vaults
    selection_window_days = var.recovery_point_selection.selection_window_days
  }

  tags = var.tags
}