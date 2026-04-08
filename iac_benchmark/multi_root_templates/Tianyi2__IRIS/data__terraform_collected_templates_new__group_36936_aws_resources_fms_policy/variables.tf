variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The friendly name of the AWS Firewall Manager Policy."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_fms_policy, name must be a non-empty string."
  }
}

variable "delete_all_policy_resources" {
  description = "If true, the request will also perform a clean-up process. Defaults to true."
  type        = bool
  default     = true
}

variable "delete_unused_fm_managed_resources" {
  description = "If true, Firewall Manager will automatically remove protections from resources that leave the policy scope. Defaults to false."
  type        = bool
  default     = false
}

variable "description" {
  description = "The description of the AWS Network Firewall firewall policy."
  type        = string
  default     = null
}

variable "exclude_map" {
  description = "A map of lists of accounts and OU's to exclude from the policy."
  type = object({
    account = optional(list(string))
    orgunit = optional(list(string))
  })
  default = null
}

variable "exclude_resource_tags" {
  description = "A boolean value, if true the tags that are specified in the resource_tags are not protected by this policy. If set to false and resource_tags are populated, resources that contain tags will be protected by this policy."
  type        = bool
}

variable "include_map" {
  description = "A map of lists of accounts and OU's to include in the policy."
  type = object({
    account = optional(list(string))
    orgunit = optional(list(string))
  })
  default = null
}

variable "remediation_enabled" {
  description = "A boolean value, indicates if the policy should automatically applied to resources that already exist in the account."
  type        = bool
}

variable "resource_tag_logical_operator" {
  description = "Controls how multiple resource tags are combined: with AND, so that a resource must have all tags to be included or excluded, or OR, so that a resource must have at least one tag. The valid values are AND and OR."
  type        = string
  default     = null

  validation {
    condition     = var.resource_tag_logical_operator == null || contains(["AND", "OR"], var.resource_tag_logical_operator)
    error_message = "resource_aws_fms_policy, resource_tag_logical_operator must be either 'AND' or 'OR'."
  }
}

variable "resource_tags" {
  description = "A map of resource tags, that if present will filter protections on resources based on the exclude_resource_tags."
  type        = map(string)
  default     = null
}

variable "resource_type" {
  description = "A resource type to protect. Conflicts with resource_type_list."
  type        = string
  default     = null
}

variable "resource_type_list" {
  description = "A list of resource types to protect. Conflicts with resource_type. Lists with only one element are not supported, instead use resource_type."
  type        = list(string)
  default     = null

  validation {
    condition     = var.resource_type_list == null || length(var.resource_type_list) > 1
    error_message = "resource_aws_fms_policy, resource_type_list must contain more than one element. Use resource_type for single element lists."
  }
}

variable "security_service_policy_data" {
  description = "The objects to include in Security Service Policy Data."
  type = object({
    managed_service_data = optional(string)
    type                 = string
    policy_option = optional(object({
      network_acl_common_policy = optional(object({
        network_acl_entry_set = optional(object({
          force_remediate_for_first_entries = bool
          force_remediate_for_last_entries  = bool
          first_entry = optional(object({
            egress          = bool
            protocol        = string
            rule_action     = string
            cidr_block      = optional(string)
            ipv6_cidr_block = optional(string)
            icmp_type_code = optional(object({
              code = optional(number)
              type = optional(number)
            }))
            port_range = optional(object({
              from = optional(number)
              to   = optional(number)
            }))
          }))
          last_entry = optional(object({
            egress          = bool
            protocol        = string
            rule_action     = string
            cidr_block      = optional(string)
            ipv6_cidr_block = optional(string)
            icmp_type_code = optional(object({
              code = optional(number)
              type = optional(number)
            }))
            port_range = optional(object({
              from = optional(number)
              to   = optional(number)
            }))
          }))
        }))
      }))
      network_firewall_policy = optional(object({
        firewall_deployment_model = optional(string)
      }))
      thirdparty_firewall_policy = optional(object({
        firewall_deployment_model = optional(string)
      }))
    }))
  })

  validation {
    condition     = length(var.security_service_policy_data.type) > 0
    error_message = "resource_aws_fms_policy, security_service_policy_data type must be a non-empty string."
  }

  validation {
    condition = var.security_service_policy_data.policy_option == null || (
      var.security_service_policy_data.policy_option.network_acl_common_policy == null ||
      var.security_service_policy_data.policy_option.network_acl_common_policy.network_acl_entry_set == null ||
      (
        var.security_service_policy_data.policy_option.network_acl_common_policy.network_acl_entry_set.first_entry == null ||
        contains(["allow", "deny"], var.security_service_policy_data.policy_option.network_acl_common_policy.network_acl_entry_set.first_entry.rule_action)
      )
    )
    error_message = "resource_aws_fms_policy, first_entry rule_action must be either 'allow' or 'deny'."
  }

  validation {
    condition = var.security_service_policy_data.policy_option == null || (
      var.security_service_policy_data.policy_option.network_acl_common_policy == null ||
      var.security_service_policy_data.policy_option.network_acl_common_policy.network_acl_entry_set == null ||
      (
        var.security_service_policy_data.policy_option.network_acl_common_policy.network_acl_entry_set.last_entry == null ||
        contains(["allow", "deny"], var.security_service_policy_data.policy_option.network_acl_common_policy.network_acl_entry_set.last_entry.rule_action)
      )
    )
    error_message = "resource_aws_fms_policy, last_entry rule_action must be either 'allow' or 'deny'."
  }

  validation {
    condition = var.security_service_policy_data.policy_option == null || (
      var.security_service_policy_data.policy_option.network_firewall_policy == null ||
      var.security_service_policy_data.policy_option.network_firewall_policy.firewall_deployment_model == null ||
      contains(["CENTRALIZED", "DISTRIBUTED"], var.security_service_policy_data.policy_option.network_firewall_policy.firewall_deployment_model)
    )
    error_message = "resource_aws_fms_policy, network_firewall_policy firewall_deployment_model must be either 'CENTRALIZED' or 'DISTRIBUTED'."
  }

  validation {
    condition = var.security_service_policy_data.policy_option == null || (
      var.security_service_policy_data.policy_option.thirdparty_firewall_policy == null ||
      var.security_service_policy_data.policy_option.thirdparty_firewall_policy.firewall_deployment_model == null ||
      contains(["CENTRALIZED", "DISTRIBUTED"], var.security_service_policy_data.policy_option.thirdparty_firewall_policy.firewall_deployment_model)
    )
    error_message = "resource_aws_fms_policy, thirdparty_firewall_policy firewall_deployment_model must be either 'CENTRALIZED' or 'DISTRIBUTED'."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}