variable "account_access_type" {
  description = "The type of account access for the workspace"
  type        = string
  validation {
    condition     = contains(["CURRENT_ACCOUNT", "ORGANIZATION"], var.account_access_type)
    error_message = "resource_aws_grafana_workspace, account_access_type must be one of: CURRENT_ACCOUNT, ORGANIZATION."
  }
}

variable "authentication_providers" {
  description = "The authentication providers for the workspace"
  type        = list(string)
  validation {
    condition     = length(var.authentication_providers) > 0 && alltrue([for provider in var.authentication_providers : contains(["AWS_SSO", "SAML"], provider)])
    error_message = "resource_aws_grafana_workspace, authentication_providers must contain at least one of: AWS_SSO, SAML."
  }
}

variable "permission_type" {
  description = "The permission type of the workspace"
  type        = string
  validation {
    condition     = contains(["SERVICE_MANAGED", "CUSTOMER_MANAGED"], var.permission_type)
    error_message = "resource_aws_grafana_workspace, permission_type must be one of: SERVICE_MANAGED, CUSTOMER_MANAGED."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "configuration" {
  description = "The configuration string for the workspace"
  type        = string
  default     = null
}

variable "data_sources" {
  description = "The data sources for the workspace"
  type        = list(string)
  default     = null
  validation {
    condition = var.data_sources == null ? true : alltrue([
      for ds in var.data_sources : contains([
        "AMAZON_OPENSEARCH_SERVICE", "ATHENA", "CLOUDWATCH", "PROMETHEUS",
        "REDSHIFT", "SITEWISE", "TIMESTREAM", "TWINMAKER", "XRAY"
      ], ds)
    ])
    error_message = "resource_aws_grafana_workspace, data_sources must contain valid values: AMAZON_OPENSEARCH_SERVICE, ATHENA, CLOUDWATCH, PROMETHEUS, REDSHIFT, SITEWISE, TIMESTREAM, TWINMAKER, XRAY."
  }
}

variable "description" {
  description = "The workspace description"
  type        = string
  default     = null
}

variable "grafana_version" {
  description = "Specifies the version of Grafana to support in the new workspace"
  type        = string
  default     = null
  validation {
    condition     = var.grafana_version == null ? true : contains(["8.4", "9.4", "10.4"], var.grafana_version)
    error_message = "resource_aws_grafana_workspace, grafana_version must be one of: 8.4, 9.4, 10.4."
  }
}

variable "name" {
  description = "The Grafana workspace name"
  type        = string
  default     = null
}

variable "network_access_control" {
  description = "Configuration for network access to your workspace"
  type = object({
    prefix_list_ids = list(string)
    vpce_ids        = list(string)
  })
  default = null
  validation {
    condition = var.network_access_control == null ? true : (
      length(var.network_access_control.prefix_list_ids) > 0 &&
      length(var.network_access_control.vpce_ids) > 0
    )
    error_message = "resource_aws_grafana_workspace, network_access_control requires both prefix_list_ids and vpce_ids to be non-empty arrays."
  }
}

variable "notification_destinations" {
  description = "The notification destinations"
  type        = list(string)
  default     = null
  validation {
    condition = var.notification_destinations == null ? true : alltrue([
      for dest in var.notification_destinations : dest == "SNS"
    ])
    error_message = "resource_aws_grafana_workspace, notification_destinations must only contain SNS."
  }
}

variable "organization_role_name" {
  description = "The role name that the workspace uses to access resources through Amazon Organizations"
  type        = string
  default     = null
}

variable "organizational_units" {
  description = "The Amazon Organizations organizational units that the workspace is authorized to use data sources from"
  type        = list(string)
  default     = null
}

variable "role_arn" {
  description = "The IAM role ARN that the workspace assumes"
  type        = string
  default     = null
}

variable "stack_set_name" {
  description = "The AWS CloudFormation stack set name that provisions IAM roles to be used by the workspace"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "vpc_configuration" {
  description = "The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to"
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
  validation {
    condition = var.vpc_configuration == null ? true : (
      length(var.vpc_configuration.security_group_ids) > 0 &&
      length(var.vpc_configuration.subnet_ids) > 0
    )
    error_message = "resource_aws_grafana_workspace, vpc_configuration requires both security_group_ids and subnet_ids to be non-empty arrays."
  }
}