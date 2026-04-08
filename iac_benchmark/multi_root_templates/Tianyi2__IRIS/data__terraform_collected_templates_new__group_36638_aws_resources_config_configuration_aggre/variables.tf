variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the configuration aggregator."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_config_configuration_aggregator, name must not be empty."
  }
}

variable "account_aggregation_source" {
  description = "The account(s) to aggregate config data from."
  type = object({
    account_ids = list(string)
    all_regions = optional(bool)
    regions     = optional(list(string))
  })
  default = null

  validation {
    condition = var.account_aggregation_source == null || (
      var.account_aggregation_source.account_ids != null &&
      length(var.account_aggregation_source.account_ids) > 0 &&
      alltrue([for id in var.account_aggregation_source.account_ids : can(regex("^[0-9]{12}$", id))])
    )
    error_message = "resource_aws_config_configuration_aggregator, account_aggregation_source.account_ids must be a list of 12-digit account IDs."
  }

  validation {
    condition = var.account_aggregation_source == null || (
      (var.account_aggregation_source.all_regions == true) ||
      (var.account_aggregation_source.regions != null && length(var.account_aggregation_source.regions) > 0)
    )
    error_message = "resource_aws_config_configuration_aggregator, account_aggregation_source must specify either regions or all_regions as true."
  }
}

variable "organization_aggregation_source" {
  description = "The organization to aggregate config data from."
  type = object({
    all_regions = optional(bool)
    regions     = optional(list(string))
    role_arn    = string
  })
  default = null

  validation {
    condition = var.organization_aggregation_source == null || (
      var.organization_aggregation_source.role_arn != null &&
      can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.organization_aggregation_source.role_arn))
    )
    error_message = "resource_aws_config_configuration_aggregator, organization_aggregation_source.role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = var.organization_aggregation_source == null || (
      (var.organization_aggregation_source.all_regions == true) ||
      (var.organization_aggregation_source.regions != null && length(var.organization_aggregation_source.regions) > 0)
    )
    error_message = "resource_aws_config_configuration_aggregator, organization_aggregation_source must specify either regions or all_regions as true."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

locals {
  # Validation for mutual exclusivity of aggregation sources
  validate_aggregation_sources = (
    (var.account_aggregation_source != null && var.organization_aggregation_source == null) ||
    (var.account_aggregation_source == null && var.organization_aggregation_source != null)
  ) ? true : tobool("resource_aws_config_configuration_aggregator, either account_aggregation_source or organization_aggregation_source must be specified, but not both.")
}