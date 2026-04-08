variable "name" {
  description = "A friendly name of the firewall policy."
  type        = string
}

variable "description" {
  description = "A friendly description of the firewall policy."
  type        = string
  default     = null
}

variable "encryption_configuration" {
  description = "KMS encryption configuration settings."
  type = object({
    key_id = optional(string)
    type   = string
  })
  default = null

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      contains(["CUSTOMER_KMS", "AWS_OWNED_KMS_KEY"], var.encryption_configuration.type)
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, encryption_configuration.type must be either 'CUSTOMER_KMS' or 'AWS_OWNED_KMS_KEY'."
  }
}

variable "firewall_policy" {
  description = "A configuration block describing the rule groups and policy actions to use in the firewall policy."
  type = object({
    stateless_default_actions          = list(string)
    stateless_fragment_default_actions = list(string)
    stateful_default_actions           = optional(list(string))
    tls_inspection_configuration_arn   = optional(string)

    policy_variables = optional(object({
      rule_variables = optional(list(object({
        key = string
        ip_set = object({
          definition = list(string)
        })
      })))
    }))

    stateful_engine_options = optional(object({
      rule_order              = optional(string, "DEFAULT_ACTION_ORDER")
      stream_exception_policy = optional(string, "DROP")
      flow_timeouts = optional(object({
        tcp_idle_timeout_seconds = optional(number, 350)
      }))
    }))

    stateful_rule_group_reference = optional(list(object({
      resource_arn           = string
      deep_threat_inspection = optional(bool)
      priority               = optional(number)
      override = optional(object({
        action = optional(string)
      }))
    })))

    stateless_custom_action = optional(list(object({
      action_name = string
      action_definition = object({
        publish_metric_action = object({
          dimension = list(object({
            value = string
          }))
        })
      })
    })))

    stateless_rule_group_reference = optional(list(object({
      priority     = number
      resource_arn = string
    })))
  })

  validation {
    condition     = length(var.firewall_policy.stateless_default_actions) > 0
    error_message = "resource_aws_networkfirewall_firewall_policy, stateless_default_actions must contain at least one action."
  }

  validation {
    condition     = length(var.firewall_policy.stateless_fragment_default_actions) > 0
    error_message = "resource_aws_networkfirewall_firewall_policy, stateless_fragment_default_actions must contain at least one action."
  }

  validation {
    condition = alltrue([
      for action in var.firewall_policy.stateless_default_actions :
      contains(["aws:drop", "aws:pass", "aws:forward_to_sfe"], action) ||
      !startswith(action, "aws:")
    ])
    error_message = "resource_aws_networkfirewall_firewall_policy, stateless_default_actions must contain valid standard actions (aws:drop, aws:pass, aws:forward_to_sfe) or custom actions."
  }

  validation {
    condition = alltrue([
      for action in var.firewall_policy.stateless_fragment_default_actions :
      contains(["aws:drop", "aws:pass", "aws:forward_to_sfe"], action) ||
      !startswith(action, "aws:")
    ])
    error_message = "resource_aws_networkfirewall_firewall_policy, stateless_fragment_default_actions must contain valid standard actions (aws:drop, aws:pass, aws:forward_to_sfe) or custom actions."
  }

  validation {
    condition = var.firewall_policy.stateful_default_actions == null || (
      var.firewall_policy.stateful_default_actions != null &&
      alltrue([
        for action in var.firewall_policy.stateful_default_actions :
        contains(["aws:drop_strict", "aws:drop_established", "aws:alert_strict", "aws:alert_established"], action)
      ])
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, stateful_default_actions must contain valid actions: aws:drop_strict, aws:drop_established, aws:alert_strict, aws:alert_established."
  }

  validation {
    condition = var.firewall_policy.stateful_engine_options == null || (
      var.firewall_policy.stateful_engine_options != null &&
      contains(["DEFAULT_ACTION_ORDER", "STRICT_ORDER"], var.firewall_policy.stateful_engine_options.rule_order)
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, stateful_engine_options.rule_order must be either 'DEFAULT_ACTION_ORDER' or 'STRICT_ORDER'."
  }

  validation {
    condition = var.firewall_policy.stateful_engine_options == null || (
      var.firewall_policy.stateful_engine_options.stream_exception_policy == null ||
      contains(["DROP", "CONTINUE", "REJECT"], var.firewall_policy.stateful_engine_options.stream_exception_policy)
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, stateful_engine_options.stream_exception_policy must be either 'DROP', 'CONTINUE', or 'REJECT'."
  }

  validation {
    condition = var.firewall_policy.policy_variables == null || (
      var.firewall_policy.policy_variables != null &&
      var.firewall_policy.policy_variables.rule_variables == null || (
        var.firewall_policy.policy_variables.rule_variables != null &&
        alltrue([
          for rv in var.firewall_policy.policy_variables.rule_variables :
          rv.key == "HOME_NET"
        ])
      )
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, policy_variables.rule_variables.key must be 'HOME_NET'."
  }

  validation {
    condition = (
      var.firewall_policy.stateful_engine_options == null ||
      var.firewall_policy.stateful_engine_options.rule_order != "STRICT_ORDER" ||
      var.firewall_policy.stateful_default_actions != null
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, stateful_default_actions must be specified when stateful_engine_options.rule_order is 'STRICT_ORDER'."
  }

  validation {
    condition = (
      var.firewall_policy.stateful_rule_group_reference == null ||
      var.firewall_policy.stateful_engine_options == null ||
      var.firewall_policy.stateful_engine_options.rule_order != "STRICT_ORDER" ||
      alltrue([
        for ref in var.firewall_policy.stateful_rule_group_reference :
        ref.priority != null
      ])
    )
    error_message = "resource_aws_networkfirewall_firewall_policy, stateful_rule_group_reference.priority must be specified when stateful_engine_options.rule_order is 'STRICT_ORDER'."
  }
}

variable "tags" {
  description = "Map of resource tags to associate with the resource."
  type        = map(string)
  default     = {}
}