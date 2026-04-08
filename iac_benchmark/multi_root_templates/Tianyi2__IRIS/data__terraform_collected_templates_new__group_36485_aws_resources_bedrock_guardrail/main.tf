resource "aws_bedrock_guardrail" "this" {
  name                      = var.name
  blocked_input_messaging   = var.blocked_input_messaging
  blocked_outputs_messaging = var.blocked_outputs_messaging
  description               = var.description
  region                    = var.region
  kms_key_arn               = var.kms_key_arn
  tags                      = var.tags

  dynamic "content_policy_config" {
    for_each = var.content_policy_config != null ? [var.content_policy_config] : []
    content {
      dynamic "filters_config" {
        for_each = content_policy_config.value.filters_config != null ? content_policy_config.value.filters_config : []
        content {
          input_strength  = filters_config.value.input_strength
          output_strength = filters_config.value.output_strength
          type            = filters_config.value.type
        }
      }

      dynamic "tier_config" {
        for_each = content_policy_config.value.tier_config != null ? [content_policy_config.value.tier_config] : []
        content {
          tier_name = tier_config.value.tier_name
        }
      }
    }
  }

  dynamic "contextual_grounding_policy_config" {
    for_each = var.contextual_grounding_policy_config != null ? [var.contextual_grounding_policy_config] : []
    content {
      dynamic "filters_config" {
        for_each = contextual_grounding_policy_config.value.filters_config != null ? contextual_grounding_policy_config.value.filters_config : []
        content {
          threshold = filters_config.value.threshold
          type      = filters_config.value.type
        }
      }
    }
  }

  dynamic "cross_region_config" {
    for_each = var.cross_region_config != null ? [var.cross_region_config] : []
    content {
      guardrail_profile_identifier = cross_region_config.value.guardrail_profile_identifier
    }
  }

  dynamic "sensitive_information_policy_config" {
    for_each = var.sensitive_information_policy_config != null ? [var.sensitive_information_policy_config] : []
    content {
      dynamic "pii_entities_config" {
        for_each = sensitive_information_policy_config.value.pii_entities_config != null ? sensitive_information_policy_config.value.pii_entities_config : []
        content {
          action         = pii_entities_config.value.action
          input_action   = pii_entities_config.value.input_action
          output_action  = pii_entities_config.value.output_action
          input_enabled  = pii_entities_config.value.input_enabled
          output_enabled = pii_entities_config.value.output_enabled
          type           = pii_entities_config.value.type
        }
      }

      dynamic "regexes_config" {
        for_each = sensitive_information_policy_config.value.regexes_config != null ? sensitive_information_policy_config.value.regexes_config : []
        content {
          action         = regexes_config.value.action
          input_action   = regexes_config.value.input_action
          output_action  = regexes_config.value.output_action
          input_enabled  = regexes_config.value.input_enabled
          output_enabled = regexes_config.value.output_enabled
          description    = regexes_config.value.description
          name           = regexes_config.value.name
          pattern        = regexes_config.value.pattern
        }
      }
    }
  }

  dynamic "topic_policy_config" {
    for_each = var.topic_policy_config != null ? [var.topic_policy_config] : []
    content {
      dynamic "topics_config" {
        for_each = topic_policy_config.value.topics_config != null ? topic_policy_config.value.topics_config : []
        content {
          name       = topics_config.value.name
          examples   = topics_config.value.examples
          type       = topics_config.value.type
          definition = topics_config.value.definition
        }
      }

      dynamic "tier_config" {
        for_each = topic_policy_config.value.tier_config != null ? [topic_policy_config.value.tier_config] : []
        content {
          tier_name = tier_config.value.tier_name
        }
      }
    }
  }

  dynamic "word_policy_config" {
    for_each = var.word_policy_config != null ? [var.word_policy_config] : []
    content {
      dynamic "managed_word_lists_config" {
        for_each = word_policy_config.value.managed_word_lists_config != null ? word_policy_config.value.managed_word_lists_config : []
        content {
          type           = managed_word_lists_config.value.type
          input_action   = managed_word_lists_config.value.input_action
          input_enabled  = managed_word_lists_config.value.input_enabled
          output_action  = managed_word_lists_config.value.output_action
          output_enabled = managed_word_lists_config.value.output_enabled
        }
      }

      dynamic "words_config" {
        for_each = word_policy_config.value.words_config != null ? word_policy_config.value.words_config : []
        content {
          text           = words_config.value.text
          input_action   = words_config.value.input_action
          input_enabled  = words_config.value.input_enabled
          output_action  = words_config.value.output_action
          output_enabled = words_config.value.output_enabled
        }
      }
    }
  }
}