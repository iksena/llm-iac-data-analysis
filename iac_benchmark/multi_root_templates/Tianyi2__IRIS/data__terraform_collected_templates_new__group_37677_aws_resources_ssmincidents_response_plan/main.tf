resource "aws_ssmincidents_response_plan" "this" {
  region       = var.region
  name         = var.name
  display_name = var.display_name
  chat_channel = var.chat_channel
  engagements  = var.engagements
  tags         = var.tags

  incident_template {
    title         = var.incident_template.title
    impact        = var.incident_template.impact
    dedupe_string = var.incident_template.dedupe_string
    incident_tags = var.incident_template.incident_tags
    summary       = var.incident_template.summary

    dynamic "notification_target" {
      for_each = var.incident_template.notification_targets != null ? var.incident_template.notification_targets : []
      content {
        sns_topic_arn = notification_target.value.sns_topic_arn
      }
    }
  }

  dynamic "action" {
    for_each = var.actions != null ? var.actions : []
    content {
      dynamic "ssm_automation" {
        for_each = action.value.ssm_automation != null ? [action.value.ssm_automation] : []
        content {
          document_name      = ssm_automation.value.document_name
          role_arn           = ssm_automation.value.role_arn
          document_version   = ssm_automation.value.document_version
          target_account     = ssm_automation.value.target_account
          dynamic_parameters = ssm_automation.value.dynamic_parameters

          dynamic "parameter" {
            for_each = ssm_automation.value.parameters != null ? ssm_automation.value.parameters : []
            content {
              name   = parameter.value.name
              values = parameter.value.values
            }
          }
        }
      }
    }
  }

  dynamic "integration" {
    for_each = var.integrations != null ? var.integrations : []
    content {
      dynamic "pagerduty" {
        for_each = integration.value.pagerduty != null ? [integration.value.pagerduty] : []
        content {
          name       = pagerduty.value.name
          service_id = pagerduty.value.service_id
          secret_id  = pagerduty.value.secret_id
        }
      }
    }
  }
}