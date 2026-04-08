resource "aws_lexv2models_slot_type" "this" {
  bot_id      = var.bot_id
  bot_version = var.bot_version
  locale_id   = var.locale_id
  name        = var.name

  region                     = var.region
  description                = var.description
  parent_slot_type_signature = var.parent_slot_type_signature

  dynamic "composite_slot_type_setting" {
    for_each = var.composite_slot_type_setting != null ? [var.composite_slot_type_setting] : []
    content {
      dynamic "sub_slots" {
        for_each = composite_slot_type_setting.value.sub_slots != null ? composite_slot_type_setting.value.sub_slots : []
        content {
          name         = sub_slots.value.name
          slot_type_id = sub_slots.value.slot_type_id
        }
      }
    }
  }

  dynamic "external_source_setting" {
    for_each = var.external_source_setting != null ? [var.external_source_setting] : []
    content {
      dynamic "grammar_slot_type_setting" {
        for_each = external_source_setting.value.grammar_slot_type_setting != null ? [external_source_setting.value.grammar_slot_type_setting] : []
        content {
          dynamic "source" {
            for_each = grammar_slot_type_setting.value.source != null ? [grammar_slot_type_setting.value.source] : []
            content {
              s3_bucket_name = source.value.s3_bucket_name
              s3_object_key  = source.value.s3_object_key
              kms_key_arn    = source.value.kms_key_arn
            }
          }
        }
      }
    }
  }

  dynamic "slot_type_values" {
    for_each = var.slot_type_values != null ? var.slot_type_values : []
    content {
      dynamic "sample_value" {
        for_each = slot_type_values.value.sample_value != null ? [slot_type_values.value.sample_value] : []
        content {
          value = sample_value.value.value
        }
      }

      dynamic "synonyms" {
        for_each = slot_type_values.value.synonyms != null ? slot_type_values.value.synonyms : []
        content {
          value = synonyms.value.value
        }
      }
    }
  }

  dynamic "value_selection_setting" {
    for_each = var.value_selection_setting != null ? [var.value_selection_setting] : []
    content {
      resolution_strategy = value_selection_setting.value.resolution_strategy

      dynamic "advanced_recognition_setting" {
        for_each = value_selection_setting.value.advanced_recognition_setting != null ? [value_selection_setting.value.advanced_recognition_setting] : []
        content {
          audio_recognition_strategy = advanced_recognition_setting.value.audio_recognition_strategy
        }
      }

      dynamic "regex_filter" {
        for_each = value_selection_setting.value.regex_filter != null ? [value_selection_setting.value.regex_filter] : []
        content {
          pattern = regex_filter.value.pattern
        }
      }
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}