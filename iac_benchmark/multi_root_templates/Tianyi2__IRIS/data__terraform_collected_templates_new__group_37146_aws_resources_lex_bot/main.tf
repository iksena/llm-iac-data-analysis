resource "aws_lex_bot" "this" {
  region = var.region

  abort_statement {
    dynamic "message" {
      for_each = var.abort_statement_messages
      content {
        content      = message.value.content
        content_type = message.value.content_type
        group_number = lookup(message.value, "group_number", null)
      }
    }
    response_card = var.abort_statement_response_card
  }

  child_directed = var.child_directed

  clarification_prompt {
    max_attempts = var.clarification_prompt_max_attempts
    dynamic "message" {
      for_each = var.clarification_prompt_messages
      content {
        content      = message.value.content
        content_type = message.value.content_type
        group_number = lookup(message.value, "group_number", null)
      }
    }
    response_card = var.clarification_prompt_response_card
  }

  create_version              = var.create_version
  description                 = var.description
  detect_sentiment            = var.detect_sentiment
  enable_model_improvements   = var.enable_model_improvements
  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  locale                      = var.locale

  dynamic "intent" {
    for_each = var.intents
    content {
      intent_name    = intent.value.intent_name
      intent_version = intent.value.intent_version
    }
  }

  name                            = var.name
  nlu_intent_confidence_threshold = var.nlu_intent_confidence_threshold
  process_behavior                = var.process_behavior
  voice_id                        = var.voice_id

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}