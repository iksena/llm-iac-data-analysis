resource "aws_cognito_risk_configuration" "this" {
  region       = var.region
  user_pool_id = var.user_pool_id
  client_id    = var.client_id

  dynamic "account_takeover_risk_configuration" {
    for_each = var.account_takeover_risk_configuration != null ? [var.account_takeover_risk_configuration] : []
    content {
      dynamic "notify_configuration" {
        for_each = [account_takeover_risk_configuration.value.notify_configuration]
        content {
          from       = notify_configuration.value.from
          reply_to   = notify_configuration.value.reply_to
          source_arn = notify_configuration.value.source_arn

          dynamic "block_email" {
            for_each = notify_configuration.value.block_email != null ? [notify_configuration.value.block_email] : []
            content {
              html_body = block_email.value.html_body
              subject   = block_email.value.subject
              text_body = block_email.value.text_body
            }
          }

          dynamic "mfa_email" {
            for_each = notify_configuration.value.mfa_email != null ? [notify_configuration.value.mfa_email] : []
            content {
              html_body = mfa_email.value.html_body
              subject   = mfa_email.value.subject
              text_body = mfa_email.value.text_body
            }
          }

          dynamic "no_action_email" {
            for_each = notify_configuration.value.no_action_email != null ? [notify_configuration.value.no_action_email] : []
            content {
              html_body = no_action_email.value.html_body
              subject   = no_action_email.value.subject
              text_body = no_action_email.value.text_body
            }
          }
        }
      }

      dynamic "actions" {
        for_each = [account_takeover_risk_configuration.value.actions]
        content {
          dynamic "high_action" {
            for_each = actions.value.high_action != null ? [actions.value.high_action] : []
            content {
              event_action = high_action.value.event_action
              notify       = high_action.value.notify
            }
          }

          dynamic "low_action" {
            for_each = actions.value.low_action != null ? [actions.value.low_action] : []
            content {
              event_action = low_action.value.event_action
              notify       = low_action.value.notify
            }
          }

          dynamic "medium_action" {
            for_each = actions.value.medium_action != null ? [actions.value.medium_action] : []
            content {
              event_action = medium_action.value.event_action
              notify       = medium_action.value.notify
            }
          }
        }
      }
    }
  }

  dynamic "compromised_credentials_risk_configuration" {
    for_each = var.compromised_credentials_risk_configuration != null ? [var.compromised_credentials_risk_configuration] : []
    content {
      event_filter = compromised_credentials_risk_configuration.value.event_filter

      dynamic "actions" {
        for_each = [compromised_credentials_risk_configuration.value.actions]
        content {
          event_action = actions.value.event_action
        }
      }
    }
  }

  dynamic "risk_exception_configuration" {
    for_each = var.risk_exception_configuration != null ? [var.risk_exception_configuration] : []
    content {
      blocked_ip_range_list = risk_exception_configuration.value.blocked_ip_range_list
      skipped_ip_range_list = risk_exception_configuration.value.skipped_ip_range_list
    }
  }
}