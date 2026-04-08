resource "aws_workspacesweb_data_protection_settings" "this" {
  display_name                  = var.display_name
  additional_encryption_context = var.additional_encryption_context
  customer_managed_key          = var.customer_managed_key
  description                   = var.description
  region                        = var.region
  tags                          = var.tags

  dynamic "inline_redaction_configuration" {
    for_each = var.inline_redaction_configuration != null ? [var.inline_redaction_configuration] : []
    content {
      global_confidence_level = inline_redaction_configuration.value.global_confidence_level
      global_enforced_urls    = inline_redaction_configuration.value.global_enforced_urls
      global_exempt_urls      = inline_redaction_configuration.value.global_exempt_urls

      dynamic "inline_redaction_pattern" {
        for_each = inline_redaction_configuration.value.inline_redaction_patterns != null ? inline_redaction_configuration.value.inline_redaction_patterns : []
        content {
          built_in_pattern_id = inline_redaction_pattern.value.built_in_pattern_id
          confidence_level    = inline_redaction_pattern.value.confidence_level
          enforced_urls       = inline_redaction_pattern.value.enforced_urls
          exempt_urls         = inline_redaction_pattern.value.exempt_urls

          dynamic "custom_pattern" {
            for_each = inline_redaction_pattern.value.custom_pattern != null ? [inline_redaction_pattern.value.custom_pattern] : []
            content {
              pattern_name        = custom_pattern.value.pattern_name
              pattern_regex       = custom_pattern.value.pattern_regex
              keyword_regex       = custom_pattern.value.keyword_regex
              pattern_description = custom_pattern.value.pattern_description
            }
          }

          redaction_place_holder {
            redaction_place_holder_type = inline_redaction_pattern.value.redaction_place_holder.redaction_place_holder_type
            redaction_place_holder_text = inline_redaction_pattern.value.redaction_place_holder.redaction_place_holder_text
          }
        }
      }
    }
  }
}