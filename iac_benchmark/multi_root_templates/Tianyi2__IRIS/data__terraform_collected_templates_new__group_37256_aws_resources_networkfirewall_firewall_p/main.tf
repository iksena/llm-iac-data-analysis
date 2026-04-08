resource "aws_networkfirewall_firewall_policy" "this" {
  name        = var.name
  description = var.description

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  firewall_policy {
    dynamic "policy_variables" {
      for_each = var.firewall_policy.policy_variables != null ? [var.firewall_policy.policy_variables] : []
      content {
        dynamic "rule_variables" {
          for_each = policy_variables.value.rule_variables != null ? policy_variables.value.rule_variables : []
          content {
            key = rule_variables.value.key
            ip_set {
              definition = rule_variables.value.ip_set.definition
            }
          }
        }
      }
    }

    stateless_default_actions          = var.firewall_policy.stateless_default_actions
    stateless_fragment_default_actions = var.firewall_policy.stateless_fragment_default_actions
    stateful_default_actions           = var.firewall_policy.stateful_default_actions
    tls_inspection_configuration_arn   = var.firewall_policy.tls_inspection_configuration_arn

    dynamic "stateful_engine_options" {
      for_each = var.firewall_policy.stateful_engine_options != null ? [var.firewall_policy.stateful_engine_options] : []
      content {
        rule_order              = stateful_engine_options.value.rule_order
        stream_exception_policy = stateful_engine_options.value.stream_exception_policy

        dynamic "flow_timeouts" {
          for_each = stateful_engine_options.value.flow_timeouts != null ? [stateful_engine_options.value.flow_timeouts] : []
          content {
            tcp_idle_timeout_seconds = flow_timeouts.value.tcp_idle_timeout_seconds
          }
        }
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = var.firewall_policy.stateful_rule_group_reference != null ? var.firewall_policy.stateful_rule_group_reference : []
      content {
        deep_threat_inspection = stateful_rule_group_reference.value.deep_threat_inspection
        priority               = stateful_rule_group_reference.value.priority
        resource_arn           = stateful_rule_group_reference.value.resource_arn

        dynamic "override" {
          for_each = stateful_rule_group_reference.value.override != null ? [stateful_rule_group_reference.value.override] : []
          content {
            action = override.value.action
          }
        }
      }
    }

    dynamic "stateless_custom_action" {
      for_each = var.firewall_policy.stateless_custom_action != null ? var.firewall_policy.stateless_custom_action : []
      content {
        action_name = stateless_custom_action.value.action_name

        action_definition {
          publish_metric_action {
            dynamic "dimension" {
              for_each = stateless_custom_action.value.action_definition.publish_metric_action.dimension
              content {
                value = dimension.value.value
              }
            }
          }
        }
      }
    }

    dynamic "stateless_rule_group_reference" {
      for_each = var.firewall_policy.stateless_rule_group_reference != null ? var.firewall_policy.stateless_rule_group_reference : []
      content {
        priority     = stateless_rule_group_reference.value.priority
        resource_arn = stateless_rule_group_reference.value.resource_arn
      }
    }
  }

  tags = var.tags
}