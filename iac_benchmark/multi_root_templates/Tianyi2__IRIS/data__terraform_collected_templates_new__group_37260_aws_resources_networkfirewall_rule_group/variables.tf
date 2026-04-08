variable "capacity" {
  description = "The maximum number of operating resources that this rule group can use"
  type        = number

  validation {
    condition     = var.capacity > 0
    error_message = "resource_aws_networkfirewall_rule_group, capacity must be greater than 0."
  }
}

variable "description" {
  description = "A friendly description of the rule group"
  type        = string
  default     = null
}

variable "name" {
  description = "A friendly name of the rule group"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,31}$", var.name))
    error_message = "resource_aws_networkfirewall_rule_group, name must start with a letter and contain only alphanumeric characters, hyphens, and underscores, and be between 1 and 32 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rules" {
  description = "The stateful rule group rules specifications in Suricata file format"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of key:value pairs to associate with the resource"
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Whether the rule group is stateless or stateful"
  type        = string

  validation {
    condition     = contains(["STATEFUL", "STATELESS"], var.type)
    error_message = "resource_aws_networkfirewall_rule_group, type must be either 'STATEFUL' or 'STATELESS'."
  }
}

variable "encryption_configuration" {
  description = "KMS encryption configuration settings"
  type = object({
    key_id = optional(string)
    type   = string
  })
  default = null

  validation {
    condition = var.encryption_configuration == null ? true : (
      contains(["CUSTOMER_KMS", "AWS_OWNED_KMS_KEY"], var.encryption_configuration.type)
    )
    error_message = "resource_aws_networkfirewall_rule_group, encryption_configuration.type must be either 'CUSTOMER_KMS' or 'AWS_OWNED_KMS_KEY'."
  }
}

variable "rule_group" {
  description = "A configuration block that defines the rule group rules"
  type = object({
    reference_sets = optional(object({
      ip_set_references = optional(list(object({
        key = string
        ip_set_reference = object({
          reference_arn = string
        })
      })))
    }))

    rule_variables = optional(object({
      ip_sets = optional(list(object({
        key = string
        ip_set = object({
          definition = list(string)
        })
      })))
      port_sets = optional(list(object({
        key = string
        port_set = object({
          definition = list(string)
        })
      })))
    }))

    rules_source = object({
      rules_string = optional(string)

      rules_source_list = optional(object({
        generated_rules_type = string
        target_types         = list(string)
        targets              = list(string)
      }))

      stateful_rule = optional(list(object({
        action = string
        header = object({
          destination      = string
          destination_port = string
          direction        = string
          protocol         = string
          source           = string
          source_port      = string
        })
        rule_option = list(object({
          keyword  = string
          settings = optional(list(string))
        }))
      })))

      stateless_rules_and_custom_actions = optional(object({
        custom_action = optional(list(object({
          action_name = string
          action_definition = object({
            publish_metric_action = object({
              dimension = list(object({
                value = string
              }))
            })
          })
        })))

        stateless_rule = list(object({
          priority = number
          rule_definition = object({
            actions = list(string)
            match_attributes = object({
              protocols = optional(list(number))

              destination = optional(list(object({
                address_definition = string
              })))

              destination_port = optional(list(object({
                from_port = number
                to_port   = optional(number)
              })))

              source = optional(list(object({
                address_definition = string
              })))

              source_port = optional(list(object({
                from_port = number
                to_port   = optional(number)
              })))

              tcp_flag = optional(list(object({
                flags = list(string)
                masks = optional(list(string))
              })))
            })
          })
        }))
      }))
    })

    stateful_rule_options = optional(object({
      rule_order = string
    }))
  })
  default = null

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.rules_source_list != null ? (
        contains(["ALLOWLIST", "DENYLIST"], var.rule_group.rules_source.rules_source_list.generated_rules_type)
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.rules_source_list.generated_rules_type must be either 'ALLOWLIST' or 'DENYLIST'."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.rules_source_list != null ? (
        alltrue([for target_type in var.rule_group.rules_source.rules_source_list.target_types : contains(["HTTP_HOST", "TLS_SNI"], target_type)])
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.rules_source_list.target_types must contain only 'HTTP_HOST' or 'TLS_SNI'."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateful_rule != null ? (
        alltrue([for rule in var.rule_group.rules_source.stateful_rule : contains(["ALERT", "DROP", "PASS", "REJECT"], rule.action)])
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateful_rule.action must be one of 'ALERT', 'DROP', 'PASS', or 'REJECT'."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateful_rule != null ? (
        alltrue([for rule in var.rule_group.rules_source.stateful_rule : contains(["ANY", "FORWARD"], rule.header.direction)])
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateful_rule.header.direction must be either 'ANY' or 'FORWARD'."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateful_rule != null ? (
        alltrue([for rule in var.rule_group.rules_source.stateful_rule : contains(["IP", "TCP", "UDP", "ICMP", "HTTP", "FTP", "TLS", "SMB", "DNS", "DCERPC", "SSH", "SMTP", "IMAP", "MSN", "KRB5", "IKEV2", "TFTP", "NTP", "DHCP"], rule.header.protocol)])
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateful_rule.header.protocol must be one of the valid protocol values."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateless_rules_and_custom_actions != null ? (
        var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule != null ? (
          alltrue([
            for rule in var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule :
            alltrue([
              for action in rule.rule_definition.actions :
              can(regex("^(aws:(pass|drop|forward_to_sfe)|[a-zA-Z][a-zA-Z0-9-_]*)$", action))
            ])
          ])
        ) : true
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule.rule_definition.actions must contain valid action values (aws:pass, aws:drop, aws:forward_to_sfe, or custom action names)."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateless_rules_and_custom_actions != null ? (
        var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule != null ? (
          alltrue([
            for rule in var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule :
            rule.rule_definition.match_attributes.tcp_flag != null ? (
              alltrue([
                for tcp_flag in rule.rule_definition.match_attributes.tcp_flag :
                alltrue([for flag in tcp_flag.flags : contains(["FIN", "SYN", "RST", "PSH", "ACK", "URG", "ECE", "CWR"], flag)]) &&
                (tcp_flag.masks != null ? alltrue([for mask in tcp_flag.masks : contains(["FIN", "SYN", "RST", "PSH", "ACK", "URG", "ECE", "CWR"], mask)]) : true)
              ])
            ) : true
          ])
        ) : true
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule.rule_definition.match_attributes.tcp_flag flags and masks must contain only valid TCP flag values."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.stateful_rule_options != null ? (
        contains(["DEFAULT_ACTION_ORDER", "STRICT_ORDER"], var.rule_group.stateful_rule_options.rule_order)
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.stateful_rule_options.rule_order must be either 'DEFAULT_ACTION_ORDER' or 'STRICT_ORDER'."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.reference_sets != null ? (
        var.rule_group.reference_sets.ip_set_references != null ? length(var.rule_group.reference_sets.ip_set_references) <= 5 : true
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.reference_sets.ip_set_references can have a maximum of 5 entries."
  }

  validation {
    condition = var.rule_group != null && var.rules != null ? false : true
    error_message = "resource_aws_networkfirewall_rule_group, only one of 'rule_group' or 'rules' can be specified."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateless_rules_and_custom_actions != null ? (
        var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule != null ? (
          alltrue([
            for rule in var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule :
            rule.rule_definition.match_attributes.destination_port != null ? (
              alltrue([
                for port in rule.rule_definition.match_attributes.destination_port :
                port.from_port >= 1 && port.from_port <= 65535 &&
                (port.to_port != null ? (port.to_port >= port.from_port && port.to_port <= 65535) : true)
              ])
            ) : true
          ])
        ) : true
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule.rule_definition.match_attributes.destination_port from_port and to_port must be between 1 and 65535, and to_port must be >= from_port."
  }

  validation {
    condition = var.rule_group == null ? true : (
      var.rule_group.rules_source.stateless_rules_and_custom_actions != null ? (
        var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule != null ? (
          alltrue([
            for rule in var.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule :
            rule.rule_definition.match_attributes.source_port != null ? (
              alltrue([
                for port in rule.rule_definition.match_attributes.source_port :
                port.from_port >= 1 && port.from_port <= 65535 &&
                (port.to_port != null ? (port.to_port >= port.from_port && port.to_port <= 65535) : true)
              ])
            ) : true
          ])
        ) : true
      ) : true
    )
    error_message = "resource_aws_networkfirewall_rule_group, rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rule.rule_definition.match_attributes.source_port from_port and to_port must be between 1 and 65535, and to_port must be >= from_port."
  }
}