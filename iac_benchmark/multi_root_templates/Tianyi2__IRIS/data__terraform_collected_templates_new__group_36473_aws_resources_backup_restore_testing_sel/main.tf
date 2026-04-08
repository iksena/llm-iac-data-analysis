resource "aws_backup_restore_testing_selection" "this" {
  region                     = var.region
  name                       = var.name
  restore_testing_plan_name  = var.restore_testing_plan_name
  protected_resource_type    = var.protected_resource_type
  iam_role_arn               = var.iam_role_arn
  protected_resource_arns    = var.protected_resource_arns
  restore_metadata_overrides = var.restore_metadata_overrides
  validation_window_hours    = var.validation_window_hours

  dynamic "protected_resource_conditions" {
    for_each = var.protected_resource_conditions != null ? [var.protected_resource_conditions] : []
    content {
      dynamic "string_equals" {
        for_each = protected_resource_conditions.value.string_equals != null ? protected_resource_conditions.value.string_equals : []
        content {
          key   = string_equals.value.key
          value = string_equals.value.value
        }
      }

      dynamic "string_not_equals" {
        for_each = protected_resource_conditions.value.string_not_equals != null ? protected_resource_conditions.value.string_not_equals : []
        content {
          key   = string_not_equals.value.key
          value = string_not_equals.value.value
        }
      }
    }
  }
}