data "aws_networkmanager_core_network_policy_document" "this" {
  dynamic "core_network_configuration" {
    for_each = var.core_network_configuration != null ? [var.core_network_configuration] : []
    content {
      asn_ranges         = core_network_configuration.value.asn_ranges
      vpn_ecmp_support   = core_network_configuration.value.vpn_ecmp_support
      inside_cidr_blocks = core_network_configuration.value.inside_cidr_blocks

      dynamic "edge_locations" {
        for_each = core_network_configuration.value.edge_locations
        content {
          location = edge_locations.value.location
          asn      = edge_locations.value.asn
        }
      }
    }
  }

  dynamic "segments" {
    for_each = var.segments != null ? var.segments : []
    content {
      name                          = segments.value.name
      description                   = segments.value.description
      edge_locations                = segments.value.edge_locations
      isolate_attachments           = segments.value.isolate_attachments
      require_attachment_acceptance = segments.value.require_attachment_acceptance
    }
  }

  dynamic "segment_actions" {
    for_each = var.segment_actions != null ? var.segment_actions : []
    content {
      action                  = segment_actions.value.action
      segment                 = segment_actions.value.segment
      destination_cidr_blocks = segment_actions.value.destination_cidr_blocks
      destinations            = segment_actions.value.destinations
      description             = segment_actions.value.description
      share_with              = segment_actions.value.share_with
    }
  }

  dynamic "attachment_policies" {
    for_each = var.attachment_policies != null ? var.attachment_policies : []
    content {
      rule_number     = attachment_policies.value.rule_number
      condition_logic = attachment_policies.value.condition_logic

      dynamic "conditions" {
        for_each = attachment_policies.value.conditions
        content {
          type     = conditions.value.type
          operator = conditions.value.operator
          key      = conditions.value.key
          value    = conditions.value.value
        }
      }

      action {
        association_method = attachment_policies.value.action.association_method
        tag_value_of_key   = attachment_policies.value.action.tag_value_of_key
        segment            = attachment_policies.value.action.segment
        require_acceptance = attachment_policies.value.action.require_acceptance
      }
    }
  }
}