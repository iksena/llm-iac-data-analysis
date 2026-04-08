resource "aws_config_config_rule" "this" {
  provider = aws.region

  name                        = var.name
  description                 = var.description
  input_parameters            = var.input_parameters
  maximum_execution_frequency = var.maximum_execution_frequency
  tags                        = var.tags

  dynamic "evaluation_mode" {
    for_each = var.evaluation_mode != null ? var.evaluation_mode : []
    content {
      mode = evaluation_mode.value.mode
    }
  }

  dynamic "scope" {
    for_each = var.scope != null ? [var.scope] : []
    content {
      compliance_resource_id    = scope.value.compliance_resource_id
      compliance_resource_types = scope.value.compliance_resource_types
      tag_key                   = scope.value.tag_key
      tag_value                 = scope.value.tag_value
    }
  }

  source {
    owner             = var.rule_source.owner
    source_identifier = var.rule_source.source_identifier

    dynamic "source_detail" {
      for_each = var.rule_source.source_detail != null ? var.rule_source.source_detail : []
      content {
        event_source                = source_detail.value.event_source
        maximum_execution_frequency = source_detail.value.maximum_execution_frequency
        message_type                = source_detail.value.message_type
      }
    }

    dynamic "custom_policy_details" {
      for_each = var.rule_source.custom_policy_details != null ? [var.rule_source.custom_policy_details] : []
      content {
        enable_debug_log_delivery = custom_policy_details.value.enable_debug_log_delivery
        policy_runtime            = custom_policy_details.value.policy_runtime
        policy_text               = custom_policy_details.value.policy_text
      }
    }
  }
}