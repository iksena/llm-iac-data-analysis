resource "aws_customerprofiles_domain" "this" {
  domain_name             = var.domain_name
  default_expiration_days = var.default_expiration_days
  region                  = var.region
  dead_letter_queue_url   = var.dead_letter_queue_url
  default_encryption_key  = var.default_encryption_key
  tags                    = var.tags

  dynamic "matching" {
    for_each = var.matching != null ? [var.matching] : []
    content {
      enabled = matching.value.enabled

      dynamic "auto_merging" {
        for_each = matching.value.auto_merging != null ? [matching.value.auto_merging] : []
        content {
          enabled                                  = auto_merging.value.enabled
          min_allowed_confidence_score_for_merging = auto_merging.value.min_allowed_confidence_score_for_merging

          dynamic "conflict_resolution" {
            for_each = auto_merging.value.conflict_resolution != null ? [auto_merging.value.conflict_resolution] : []
            content {
              conflict_resolving_model = conflict_resolution.value.conflict_resolving_model
              source_name              = conflict_resolution.value.source_name
            }
          }

          dynamic "consolidation" {
            for_each = auto_merging.value.consolidation != null ? [auto_merging.value.consolidation] : []
            content {
              matching_attributes_list = consolidation.value.matching_attributes_list
            }
          }
        }
      }

      dynamic "exporting_config" {
        for_each = matching.value.exporting_config != null ? [matching.value.exporting_config] : []
        content {
          dynamic "s3_exporting" {
            for_each = exporting_config.value.s3_exporting_config != null ? [exporting_config.value.s3_exporting_config] : []
            content {
              s3_bucket_name = s3_exporting.value.s3_bucket_name
              s3_key_name    = s3_exporting.value.s3_key_name
            }
          }
        }
      }

      dynamic "job_schedule" {
        for_each = matching.value.job_schedule != null ? [matching.value.job_schedule] : []
        content {
          day_of_the_week = job_schedule.value.day_of_the_week
          time            = job_schedule.value.time
        }
      }
    }
  }

  dynamic "rule_based_matching" {
    for_each = var.rule_based_matching != null ? [var.rule_based_matching] : []
    content {
      enabled                             = rule_based_matching.value.enabled
      max_allowed_rule_level_for_matching = rule_based_matching.value.max_allowed_rule_level_for_matching
      max_allowed_rule_level_for_merging  = rule_based_matching.value.max_allowed_rule_level_for_merging

      dynamic "attribute_types_selector" {
        for_each = rule_based_matching.value.attribute_types_selector != null ? [rule_based_matching.value.attribute_types_selector] : []
        content {
          attribute_matching_model = attribute_types_selector.value.attribute_matching_model
          address                  = attribute_types_selector.value.address
          email_address            = attribute_types_selector.value.email_address
          phone_number             = attribute_types_selector.value.phone_number
        }
      }

      dynamic "conflict_resolution" {
        for_each = rule_based_matching.value.conflict_resolution != null ? [rule_based_matching.value.conflict_resolution] : []
        content {
          conflict_resolving_model = conflict_resolution.value.conflict_resolving_model
          source_name              = conflict_resolution.value.source_name
        }
      }

      dynamic "exporting_config" {
        for_each = rule_based_matching.value.exporting_config != null ? [rule_based_matching.value.exporting_config] : []
        content {
          dynamic "s3_exporting" {
            for_each = exporting_config.value.s3_exporting_config != null ? [exporting_config.value.s3_exporting_config] : []
            content {
              s3_bucket_name = s3_exporting.value.s3_bucket_name
              s3_key_name    = s3_exporting.value.s3_key_name
            }
          }
        }
      }

      dynamic "matching_rules" {
        for_each = rule_based_matching.value.matching_rules != null ? [rule_based_matching.value.matching_rules] : []
        content {
          rule = matching_rules.value.rule
        }
      }
    }
  }

}