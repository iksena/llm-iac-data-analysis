variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "admins" {
  description = "Set of ARNs of AWS Lake Formation principals (IAM users or roles)."
  type        = set(string)
  default     = null
}

variable "allow_external_data_filtering" {
  description = "Whether to allow Amazon EMR clusters to access data managed by Lake Formation."
  type        = bool
  default     = null
}

variable "allow_full_table_external_data_access" {
  description = "Whether to allow a third-party query engine to get data access credentials without session tags when a caller has full data access permissions."
  type        = bool
  default     = null
}

variable "authorized_session_tag_value_list" {
  description = "Lake Formation relies on a privileged process secured by Amazon EMR or the third party integrator to tag the user's role while assuming it."
  type        = list(string)
  default     = null
}

variable "catalog_id" {
  description = "Identifier for the Data Catalog. By default, the account ID."
  type        = string
  default     = null
}

variable "create_database_default_permissions" {
  description = "Up to three configuration blocks of principal permissions for default create database permissions."
  type = list(object({
    region      = optional(string)
    permissions = optional(list(string))
    principal   = optional(string)
  }))
  default = null

  validation {
    condition     = var.create_database_default_permissions == null ? true : length(var.create_database_default_permissions) <= 3
    error_message = "resource_aws_lakeformation_data_lake_settings, create_database_default_permissions can have up to three configuration blocks."
  }

  validation {
    condition = var.create_database_default_permissions == null ? true : alltrue([
      for perm in var.create_database_default_permissions : alltrue([
        for permission in coalesce(perm.permissions, []) : contains(["ALL", "SELECT", "ALTER", "DROP", "DELETE", "INSERT", "DESCRIBE", "CREATE_TABLE"], permission)
      ])
    ])
    error_message = "resource_aws_lakeformation_data_lake_settings, create_database_default_permissions permissions must be one of: ALL, SELECT, ALTER, DROP, DELETE, INSERT, DESCRIBE, CREATE_TABLE."
  }
}

variable "create_table_default_permissions" {
  description = "Up to three configuration blocks of principal permissions for default create table permissions."
  type = list(object({
    region      = optional(string)
    permissions = optional(list(string))
    principal   = optional(string)
  }))
  default = null

  validation {
    condition     = var.create_table_default_permissions == null ? true : length(var.create_table_default_permissions) <= 3
    error_message = "resource_aws_lakeformation_data_lake_settings, create_table_default_permissions can have up to three configuration blocks."
  }

  validation {
    condition = var.create_table_default_permissions == null ? true : alltrue([
      for perm in var.create_table_default_permissions : alltrue([
        for permission in coalesce(perm.permissions, []) : contains(["ALL", "SELECT", "ALTER", "DROP", "DELETE", "INSERT", "DESCRIBE"], permission)
      ])
    ])
    error_message = "resource_aws_lakeformation_data_lake_settings, create_table_default_permissions permissions must be one of: ALL, SELECT, ALTER, DROP, DELETE, INSERT, DESCRIBE."
  }
}

variable "external_data_filtering_allow_list" {
  description = "A list of the account IDs of Amazon Web Services accounts with Amazon EMR clusters that are to perform data filtering."
  type        = list(string)
  default     = null
}

variable "parameters" {
  description = "Key-value map of additional configuration. Valid values for the CROSS_ACCOUNT_VERSION key are 1, 2, 3, or 4."
  type        = map(string)
  default     = null

  validation {
    condition = var.parameters == null ? true : (
      lookup(var.parameters, "CROSS_ACCOUNT_VERSION", null) == null ? true :
      contains(["1", "2", "3", "4"], lookup(var.parameters, "CROSS_ACCOUNT_VERSION", ""))
    )
    error_message = "resource_aws_lakeformation_data_lake_settings, parameters CROSS_ACCOUNT_VERSION must be one of: 1, 2, 3, 4."
  }
}

variable "read_only_admins" {
  description = "Set of ARNs of AWS Lake Formation principals (IAM users or roles) with only view access to the resources."
  type        = set(string)
  default     = null
}

variable "trusted_resource_owners" {
  description = "List of the resource-owning account IDs that the caller's account can use to share their user access details (user ARNs)."
  type        = list(string)
  default     = null
}