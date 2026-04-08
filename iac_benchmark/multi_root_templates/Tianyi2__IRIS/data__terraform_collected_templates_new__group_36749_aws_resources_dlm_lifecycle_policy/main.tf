resource "aws_dlm_lifecycle_policy" "this" {
  region             = var.region
  description        = var.description
  execution_role_arn = var.execution_role_arn
  default_policy     = var.default_policy
  state              = var.state
  tags               = var.tags

  dynamic "policy_details" {
    for_each = var.policy_details != null ? [var.policy_details] : []
    content {
      copy_tags          = policy_details.value.copy_tags
      create_interval    = policy_details.value.create_interval
      extend_deletion    = policy_details.value.extend_deletion
      retain_interval    = policy_details.value.retain_interval
      resource_type      = policy_details.value.resource_type
      resource_types     = policy_details.value.resource_types
      resource_locations = policy_details.value.resource_locations
      policy_language    = policy_details.value.policy_language
      policy_type        = policy_details.value.policy_type
      target_tags        = policy_details.value.target_tags

      dynamic "action" {
        for_each = policy_details.value.action != null ? [policy_details.value.action] : []
        content {
          name = action.value.name

          dynamic "cross_region_copy" {
            for_each = action.value.cross_region_copy != null ? [action.value.cross_region_copy] : []
            content {
              target = cross_region_copy.value.target

              dynamic "encryption_configuration" {
                for_each = cross_region_copy.value.encryption_configuration != null ? [cross_region_copy.value.encryption_configuration] : []
                content {
                  cmk_arn   = encryption_configuration.value.cmk_arn
                  encrypted = encryption_configuration.value.encrypted
                }
              }

              dynamic "retain_rule" {
                for_each = cross_region_copy.value.retain_rule != null ? [cross_region_copy.value.retain_rule] : []
                content {
                  interval      = retain_rule.value.interval
                  interval_unit = retain_rule.value.interval_unit
                }
              }
            }
          }
        }
      }

      dynamic "event_source" {
        for_each = policy_details.value.event_source != null ? [policy_details.value.event_source] : []
        content {
          type = event_source.value.type

          dynamic "parameters" {
            for_each = event_source.value.parameters != null ? [event_source.value.parameters] : []
            content {
              description_regex = parameters.value.description_regex
              event_type        = parameters.value.event_type
              snapshot_owner    = parameters.value.snapshot_owner
            }
          }
        }
      }

      dynamic "exclusions" {
        for_each = policy_details.value.exclusions != null ? [policy_details.value.exclusions] : []
        content {
          exclude_boot_volumes = exclusions.value.exclude_boot_volumes
          exclude_tags         = exclusions.value.exclude_tags
          exclude_volume_types = exclusions.value.exclude_volume_types
        }
      }

      dynamic "parameters" {
        for_each = policy_details.value.parameters != null ? [policy_details.value.parameters] : []
        content {
          exclude_boot_volume = parameters.value.exclude_boot_volume
          no_reboot           = parameters.value.no_reboot
        }
      }

      dynamic "schedule" {
        for_each = policy_details.value.schedule != null ? policy_details.value.schedule : []
        content {
          name          = schedule.value.name
          copy_tags     = schedule.value.copy_tags
          tags_to_add   = schedule.value.tags_to_add
          variable_tags = schedule.value.variable_tags

          dynamic "archive_rule" {
            for_each = schedule.value.archive_rule != null ? [schedule.value.archive_rule] : []
            content {
              dynamic "archive_retain_rule" {
                for_each = archive_rule.value.archive_retain_rule != null ? [archive_rule.value.archive_retain_rule] : []
                content {
                  dynamic "retention_archive_tier" {
                    for_each = archive_retain_rule.value.retention_archive_tier != null ? [archive_retain_rule.value.retention_archive_tier] : []
                    content {
                      count         = retention_archive_tier.value.count
                      interval      = retention_archive_tier.value.interval
                      interval_unit = retention_archive_tier.value.interval_unit
                    }
                  }
                }
              }
            }
          }

          dynamic "create_rule" {
            for_each = schedule.value.create_rule != null ? [schedule.value.create_rule] : []
            content {
              cron_expression = create_rule.value.cron_expression
              interval        = create_rule.value.interval
              interval_unit   = create_rule.value.interval_unit
              location        = create_rule.value.location
              times           = create_rule.value.times

              dynamic "scripts" {
                for_each = create_rule.value.scripts != null ? [create_rule.value.scripts] : []
                content {
                  execute_operation_on_script_failure = scripts.value.execute_operation_on_script_failure
                  execution_handler                   = scripts.value.execution_handler
                  execution_handler_service           = scripts.value.execution_handler_service
                  execution_timeout                   = scripts.value.execution_timeout
                  maximum_retry_count                 = scripts.value.maximum_retry_count
                  stages                              = scripts.value.stages
                }
              }
            }
          }

          dynamic "cross_region_copy_rule" {
            for_each = schedule.value.cross_region_copy_rule != null ? schedule.value.cross_region_copy_rule : []
            content {
              cmk_arn       = cross_region_copy_rule.value.cmk_arn
              copy_tags     = cross_region_copy_rule.value.copy_tags
              encrypted     = cross_region_copy_rule.value.encrypted
              target        = cross_region_copy_rule.value.target
              target_region = cross_region_copy_rule.value.target_region

              dynamic "deprecate_rule" {
                for_each = cross_region_copy_rule.value.deprecate_rule != null ? [cross_region_copy_rule.value.deprecate_rule] : []
                content {
                  interval      = deprecate_rule.value.interval
                  interval_unit = deprecate_rule.value.interval_unit
                }
              }

              dynamic "retain_rule" {
                for_each = cross_region_copy_rule.value.retain_rule != null ? [cross_region_copy_rule.value.retain_rule] : []
                content {
                  interval      = retain_rule.value.interval
                  interval_unit = retain_rule.value.interval_unit
                }
              }
            }
          }

          dynamic "deprecate_rule" {
            for_each = schedule.value.deprecate_rule != null ? [schedule.value.deprecate_rule] : []
            content {
              count         = deprecate_rule.value.count
              interval      = deprecate_rule.value.interval
              interval_unit = deprecate_rule.value.interval_unit
            }
          }

          dynamic "fast_restore_rule" {
            for_each = schedule.value.fast_restore_rule != null ? [schedule.value.fast_restore_rule] : []
            content {
              availability_zones = fast_restore_rule.value.availability_zones
              count              = fast_restore_rule.value.count
              interval           = fast_restore_rule.value.interval
              interval_unit      = fast_restore_rule.value.interval_unit
            }
          }

          dynamic "retain_rule" {
            for_each = schedule.value.retain_rule != null ? [schedule.value.retain_rule] : []
            content {
              count         = retain_rule.value.count
              interval      = retain_rule.value.interval
              interval_unit = retain_rule.value.interval_unit
            }
          }

          dynamic "share_rule" {
            for_each = schedule.value.share_rule != null ? [schedule.value.share_rule] : []
            content {
              target_accounts       = share_rule.value.target_accounts
              unshare_interval      = share_rule.value.unshare_interval
              unshare_interval_unit = share_rule.value.unshare_interval_unit
            }
          }
        }
      }
    }
  }
}