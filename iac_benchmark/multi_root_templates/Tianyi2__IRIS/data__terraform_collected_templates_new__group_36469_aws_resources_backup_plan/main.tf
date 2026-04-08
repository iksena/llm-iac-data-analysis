resource "aws_backup_plan" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags

  dynamic "rule" {
    for_each = var.rule
    content {
      rule_name                    = rule.value.rule_name
      target_vault_name            = rule.value.target_vault_name
      schedule                     = rule.value.schedule
      schedule_expression_timezone = rule.value.schedule_expression_timezone
      enable_continuous_backup     = rule.value.enable_continuous_backup
      start_window                 = rule.value.start_window
      completion_window            = rule.value.completion_window
      recovery_point_tags          = rule.value.recovery_point_tags

      dynamic "lifecycle" {
        for_each = rule.value.lifecycle != null ? [rule.value.lifecycle] : []
        content {
          cold_storage_after                        = lifecycle.value.cold_storage_after
          delete_after                              = lifecycle.value.delete_after
          opt_in_to_archive_for_supported_resources = lifecycle.value.opt_in_to_archive_for_supported_resources
        }
      }

      dynamic "copy_action" {
        for_each = rule.value.copy_action != null ? rule.value.copy_action : []
        content {
          destination_vault_arn = copy_action.value.destination_vault_arn

          dynamic "lifecycle" {
            for_each = copy_action.value.lifecycle != null ? [copy_action.value.lifecycle] : []
            content {
              cold_storage_after                        = lifecycle.value.cold_storage_after
              delete_after                              = lifecycle.value.delete_after
              opt_in_to_archive_for_supported_resources = lifecycle.value.opt_in_to_archive_for_supported_resources
            }
          }
        }
      }
    }
  }

  dynamic "advanced_backup_setting" {
    for_each = var.advanced_backup_setting != null ? var.advanced_backup_setting : []
    content {
      backup_options = advanced_backup_setting.value.backup_options
      resource_type  = advanced_backup_setting.value.resource_type
    }
  }
}