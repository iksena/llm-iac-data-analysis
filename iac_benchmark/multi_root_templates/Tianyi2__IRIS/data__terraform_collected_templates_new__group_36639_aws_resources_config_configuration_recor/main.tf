resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = var.role_arn
  region   = var.region

  dynamic "recording_group" {
    for_each = var.recording_group != null ? [var.recording_group] : []
    content {
      all_supported                 = recording_group.value.all_supported
      include_global_resource_types = recording_group.value.include_global_resource_types
      resource_types                = recording_group.value.resource_types

      dynamic "exclusion_by_resource_types" {
        for_each = recording_group.value.exclusion_by_resource_types != null ? [recording_group.value.exclusion_by_resource_types] : []
        content {
          resource_types = exclusion_by_resource_types.value.resource_types
        }
      }

      dynamic "recording_strategy" {
        for_each = recording_group.value.recording_strategy != null ? [recording_group.value.recording_strategy] : []
        content {
          use_only = recording_strategy.value.use_only
        }
      }
    }
  }

  dynamic "recording_mode" {
    for_each = var.recording_mode != null ? [var.recording_mode] : []
    content {
      recording_frequency = recording_mode.value.recording_frequency

      dynamic "recording_mode_override" {
        for_each = recording_mode.value.recording_mode_overrides != null ? recording_mode.value.recording_mode_overrides : []
        content {
          description         = recording_mode_override.value.description
          resource_types      = recording_mode_override.value.resource_types
          recording_frequency = recording_mode_override.value.recording_frequency
        }
      }
    }
  }
}