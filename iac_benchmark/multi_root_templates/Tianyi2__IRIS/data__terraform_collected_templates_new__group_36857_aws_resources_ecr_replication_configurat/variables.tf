variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "replication_configuration_rules" {
  description = "The replication rules for a replication configuration. A maximum of 10 are allowed per replication_configuration."
  type = list(object({
    destinations = list(object({
      region      = string
      registry_id = string
    }))
    repository_filter = optional(object({
      filter      = string
      filter_type = string
    }))
  }))

  validation {
    condition     = length(var.replication_configuration_rules) <= 10
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: A maximum of 10 rules are allowed per replication_configuration."
  }

  validation {
    condition = alltrue([
      for rule in var.replication_configuration_rules :
      length(rule.destinations) <= 25
    ])
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: A maximum of 25 destinations are allowed per rule."
  }

  validation {
    condition = alltrue([
      for rule in var.replication_configuration_rules :
      length(rule.destinations) > 0
    ])
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: At least one destination is required per rule."
  }

  validation {
    condition = alltrue([
      for rule in var.replication_configuration_rules :
      alltrue([
        for destination in rule.destinations :
        destination.region != null && destination.region != ""
      ])
    ])
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: destination region is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for rule in var.replication_configuration_rules :
      alltrue([
        for destination in rule.destinations :
        destination.registry_id != null && destination.registry_id != ""
      ])
    ])
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: destination registry_id is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for rule in var.replication_configuration_rules :
      rule.repository_filter == null || (
        rule.repository_filter.filter != null &&
        rule.repository_filter.filter != "" &&
        rule.repository_filter.filter_type != null &&
        rule.repository_filter.filter_type != ""
      )
    ])
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: repository_filter filter and filter_type are required when repository_filter is specified."
  }

  validation {
    condition = alltrue([
      for rule in var.replication_configuration_rules :
      rule.repository_filter == null || rule.repository_filter.filter_type == "PREFIX_MATCH"
    ])
    error_message = "resource_aws_ecr_replication_configuration, replication_configuration_rules: repository_filter filter_type must be 'PREFIX_MATCH'."
  }
}