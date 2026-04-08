resource "aws_lex_intent" "this" {
  name                    = var.name
  description             = var.description
  create_version          = var.create_version
  parent_intent_signature = var.parent_intent_signature
  sample_utterances       = var.sample_utterances

  dynamic "confirmation_prompt" {
    for_each = var.confirmation_prompt != null ? [var.confirmation_prompt] : []
    content {
      max_attempts  = confirmation_prompt.value.max_attempts
      response_card = confirmation_prompt.value.response_card

      dynamic "message" {
        for_each = confirmation_prompt.value.messages
        content {
          content      = message.value.content
          content_type = message.value.content_type
          group_number = message.value.group_number
        }
      }
    }
  }

  dynamic "conclusion_statement" {
    for_each = var.conclusion_statement != null ? [var.conclusion_statement] : []
    content {
      response_card = conclusion_statement.value.response_card

      dynamic "message" {
        for_each = conclusion_statement.value.messages
        content {
          content      = message.value.content
          content_type = message.value.content_type
          group_number = message.value.group_number
        }
      }
    }
  }

  dynamic "dialog_code_hook" {
    for_each = var.dialog_code_hook != null ? [var.dialog_code_hook] : []
    content {
      message_version = dialog_code_hook.value.message_version
      uri             = dialog_code_hook.value.uri
    }
  }

  dynamic "follow_up_prompt" {
    for_each = var.follow_up_prompt != null ? [var.follow_up_prompt] : []
    content {
      prompt {
        max_attempts  = follow_up_prompt.value.prompt.max_attempts
        response_card = follow_up_prompt.value.prompt.response_card

        dynamic "message" {
          for_each = follow_up_prompt.value.prompt.messages
          content {
            content      = message.value.content
            content_type = message.value.content_type
            group_number = message.value.group_number
          }
        }
      }

      dynamic "rejection_statement" {
        for_each = follow_up_prompt.value.rejection_statement != null ? [follow_up_prompt.value.rejection_statement] : []
        content {
          response_card = rejection_statement.value.response_card

          dynamic "message" {
            for_each = rejection_statement.value.messages
            content {
              content      = message.value.content
              content_type = message.value.content_type
              group_number = message.value.group_number
            }
          }
        }
      }
    }
  }

  fulfillment_activity {
    type = var.fulfillment_activity.type

    dynamic "code_hook" {
      for_each = var.fulfillment_activity.code_hook != null ? [var.fulfillment_activity.code_hook] : []
      content {
        message_version = code_hook.value.message_version
        uri             = code_hook.value.uri
      }
    }
  }

  dynamic "rejection_statement" {
    for_each = var.rejection_statement != null ? [var.rejection_statement] : []
    content {
      response_card = rejection_statement.value.response_card

      dynamic "message" {
        for_each = rejection_statement.value.messages
        content {
          content      = message.value.content
          content_type = message.value.content_type
          group_number = message.value.group_number
        }
      }
    }
  }

  dynamic "slot" {
    for_each = var.slots
    content {
      name              = slot.value.name
      description       = slot.value.description
      priority          = slot.value.priority
      response_card     = slot.value.response_card
      sample_utterances = slot.value.sample_utterances
      slot_constraint   = slot.value.slot_constraint
      slot_type         = slot.value.slot_type
      slot_type_version = slot.value.slot_type_version

      dynamic "value_elicitation_prompt" {
        for_each = slot.value.value_elicitation_prompt != null ? [slot.value.value_elicitation_prompt] : []
        content {
          max_attempts  = value_elicitation_prompt.value.max_attempts
          response_card = value_elicitation_prompt.value.response_card

          dynamic "message" {
            for_each = value_elicitation_prompt.value.messages
            content {
              content      = message.value.content
              content_type = message.value.content_type
              group_number = message.value.group_number
            }
          }
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}