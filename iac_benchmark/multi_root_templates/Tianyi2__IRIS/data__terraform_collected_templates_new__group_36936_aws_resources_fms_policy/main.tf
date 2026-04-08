resource "aws_fms_policy" "this" {
  region                             = var.region
  name                               = var.name
  delete_all_policy_resources        = var.delete_all_policy_resources
  delete_unused_fm_managed_resources = var.delete_unused_fm_managed_resources
  description                        = var.description
  exclude_resource_tags              = var.exclude_resource_tags
  remediation_enabled                = var.remediation_enabled
  resource_tag_logical_operator      = var.resource_tag_logical_operator
  resource_tags                      = var.resource_tags
  resource_type                      = var.resource_type
  resource_type_list                 = var.resource_type_list
  tags                               = var.tags

  dynamic "exclude_map" {
    for_each = var.exclude_map != null ? [var.exclude_map] : []
    content {
      account = exclude_map.value.account
      orgunit = exclude_map.value.orgunit
    }
  }

  dynamic "include_map" {
    for_each = var.include_map != null ? [var.include_map] : []
    content {
      account = include_map.value.account
      orgunit = include_map.value.orgunit
    }
  }

  security_service_policy_data {
    managed_service_data = var.security_service_policy_data.managed_service_data
    type                 = var.security_service_policy_data.type

    dynamic "policy_option" {
      for_each = var.security_service_policy_data.policy_option != null ? [var.security_service_policy_data.policy_option] : []
      content {
        dynamic "network_acl_common_policy" {
          for_each = policy_option.value.network_acl_common_policy != null ? [policy_option.value.network_acl_common_policy] : []
          content {
            dynamic "network_acl_entry_set" {
              for_each = network_acl_common_policy.value.network_acl_entry_set != null ? [network_acl_common_policy.value.network_acl_entry_set] : []
              content {
                force_remediate_for_first_entries = network_acl_entry_set.value.force_remediate_for_first_entries
                force_remediate_for_last_entries  = network_acl_entry_set.value.force_remediate_for_last_entries

                dynamic "first_entry" {
                  for_each = network_acl_entry_set.value.first_entry != null ? [network_acl_entry_set.value.first_entry] : []
                  content {
                    egress          = first_entry.value.egress
                    protocol        = first_entry.value.protocol
                    rule_action     = first_entry.value.rule_action
                    cidr_block      = first_entry.value.cidr_block
                    ipv6_cidr_block = first_entry.value.ipv6_cidr_block

                    dynamic "icmp_type_code" {
                      for_each = first_entry.value.icmp_type_code != null ? [first_entry.value.icmp_type_code] : []
                      content {
                        code = icmp_type_code.value.code
                        type = icmp_type_code.value.type
                      }
                    }

                    dynamic "port_range" {
                      for_each = first_entry.value.port_range != null ? [first_entry.value.port_range] : []
                      content {
                        from = port_range.value.from
                        to   = port_range.value.to
                      }
                    }
                  }
                }

                dynamic "last_entry" {
                  for_each = network_acl_entry_set.value.last_entry != null ? [network_acl_entry_set.value.last_entry] : []
                  content {
                    egress          = last_entry.value.egress
                    protocol        = last_entry.value.protocol
                    rule_action     = last_entry.value.rule_action
                    cidr_block      = last_entry.value.cidr_block
                    ipv6_cidr_block = last_entry.value.ipv6_cidr_block

                    dynamic "icmp_type_code" {
                      for_each = last_entry.value.icmp_type_code != null ? [last_entry.value.icmp_type_code] : []
                      content {
                        code = icmp_type_code.value.code
                        type = icmp_type_code.value.type
                      }
                    }

                    dynamic "port_range" {
                      for_each = last_entry.value.port_range != null ? [last_entry.value.port_range] : []
                      content {
                        from = port_range.value.from
                        to   = port_range.value.to
                      }
                    }
                  }
                }
              }
            }
          }
        }

        dynamic "network_firewall_policy" {
          for_each = policy_option.value.network_firewall_policy != null ? [policy_option.value.network_firewall_policy] : []
          content {
            firewall_deployment_model = network_firewall_policy.value.firewall_deployment_model
          }
        }

        dynamic "third_party_firewall_policy" {
          for_each = policy_option.value.third_party_firewall_policy != null ? [policy_option.value.third_party_firewall_policy] : []
          content {
            firewall_deployment_model = third_party_firewall_policy.value.firewall_deployment_model
          }
        }
      }
    }
  }
}