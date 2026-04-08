variable "core_network_configuration" {
  description = "Core network configuration block"
  type = object({
    asn_ranges         = list(string)
    vpn_ecmp_support   = optional(bool, true)
    inside_cidr_blocks = optional(list(string))
    edge_locations = list(object({
      location = string
      asn      = number
    }))
  })
  default = null

  validation {
    condition = var.core_network_configuration == null || (
      var.core_network_configuration.asn_ranges != null &&
      length(var.core_network_configuration.asn_ranges) > 0
    )
    error_message = "data_networkmanager_core_network_policy_document, core_network_configuration asn_ranges is required when core_network_configuration is specified."
  }

  validation {
    condition = var.core_network_configuration == null || (
      var.core_network_configuration.edge_locations != null &&
      length(var.core_network_configuration.edge_locations) > 0
    )
    error_message = "data_networkmanager_core_network_policy_document, core_network_configuration edge_locations is required when core_network_configuration is specified."
  }
}

variable "segments" {
  description = "List of network segments"
  type = list(object({
    name                          = string
    description                   = optional(string)
    edge_locations                = optional(list(string))
    isolate_attachments           = optional(bool, false)
    require_attachment_acceptance = optional(bool, true)
  }))
  default = null

  validation {
    condition = var.segments == null || alltrue([
      for segment in var.segments : segment.name != null && segment.name != ""
    ])
    error_message = "data_networkmanager_core_network_policy_document, segments name is required for each segment."
  }
}

variable "segment_actions" {
  description = "List of segment actions"
  type = list(object({
    action                  = string
    segment                 = string
    destination_cidr_blocks = optional(list(string))
    destinations            = optional(list(string))
    description             = optional(string)
    share_with              = optional(list(string))
  }))
  default = null

  validation {
    condition = var.segment_actions == null || alltrue([
      for action in var.segment_actions : contains(["create-route", "share"], action.action)
    ])
    error_message = "data_networkmanager_core_network_policy_document, segment_actions action must be either 'create-route' or 'share'."
  }

  validation {
    condition = var.segment_actions == null || alltrue([
      for action in var.segment_actions : action.segment != null && action.segment != ""
    ])
    error_message = "data_networkmanager_core_network_policy_document, segment_actions segment is required for each segment action."
  }
}

variable "attachment_policies" {
  description = "List of attachment policies"
  type = list(object({
    rule_number     = number
    condition_logic = optional(string, "or")
    conditions = list(object({
      type     = string
      operator = optional(string)
      key      = optional(string)
      value    = optional(string)
    }))
    action = object({
      association_method = string
      tag_value_of_key   = optional(string)
      segment            = optional(string)
      require_acceptance = optional(bool)
      description        = optional(string)
    })
  }))
  default = null

  validation {
    condition = var.attachment_policies == null || alltrue([
      for policy in var.attachment_policies : policy.rule_number != null
    ])
    error_message = "data_networkmanager_core_network_policy_document, attachment_policies rule_number is required for each attachment policy."
  }

  validation {
    condition = var.attachment_policies == null || alltrue([
      for policy in var.attachment_policies : policy.conditions != null && length(policy.conditions) > 0
    ])
    error_message = "data_networkmanager_core_network_policy_document, attachment_policies conditions is required for each attachment policy."
  }

  validation {
    condition = var.attachment_policies == null || alltrue([
      for policy in var.attachment_policies : alltrue([
        for condition in policy.conditions : contains([
          "account-id", "any", "tag-value", "tag-exists", "resource-id", "region"
        ], condition.type)
      ])
    ])
    error_message = "data_networkmanager_core_network_policy_document, attachment_policies conditions type must be one of: 'account-id', 'any', 'tag-value', 'tag-exists', 'resource-id', 'region'."
  }

  validation {
    condition = var.attachment_policies == null || alltrue([
      for policy in var.attachment_policies : alltrue([
        for condition in policy.conditions : condition.operator == null || contains([
          "equals", "not-equals", "contains", "begins-with"
        ], condition.operator)
      ])
    ])
    error_message = "data_networkmanager_core_network_policy_document, attachment_policies conditions operator must be one of: 'equals', 'not-equals', 'contains', 'begins-with'."
  }

  validation {
    condition = var.attachment_policies == null || alltrue([
      for policy in var.attachment_policies : policy.action != null
    ])
    error_message = "data_networkmanager_core_network_policy_document, attachment_policies action is required for each attachment policy."
  }

  validation {
    condition = var.attachment_policies == null || alltrue([
      for policy in var.attachment_policies : contains([
        "constant", "tag"
      ], policy.action.association_method)
    ])
    error_message = "data_networkmanager_core_network_policy_document, attachment_policies action association_method must be either 'constant' or 'tag'."
  }
}