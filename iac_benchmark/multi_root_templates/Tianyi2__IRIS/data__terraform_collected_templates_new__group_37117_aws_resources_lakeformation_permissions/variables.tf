variable "permissions" {
  description = "List of permissions granted to the principal. Valid values may include ALL, ALTER, ASSOCIATE, CREATE_DATABASE, CREATE_TABLE, DATA_LOCATION_ACCESS, DELETE, DESCRIBE, DROP, INSERT, and SELECT."
  type        = list(string)

  validation {
    condition = alltrue([
      for permission in var.permissions : contains([
        "ALL", "ALTER", "ASSOCIATE", "CREATE_DATABASE", "CREATE_TABLE",
        "DATA_LOCATION_ACCESS", "DELETE", "DESCRIBE", "DROP", "INSERT", "SELECT"
      ], permission)
    ])
    error_message = "resource_aws_lakeformation_permissions, permissions: Valid permissions are ALL, ALTER, ASSOCIATE, CREATE_DATABASE, CREATE_TABLE, DATA_LOCATION_ACCESS, DELETE, DESCRIBE, DROP, INSERT, and SELECT."
  }
}

variable "principal" {
  description = "Principal to be granted the permissions on the resource. Supported principals include IAM_ALLOWED_PRINCIPALS, IAM roles, users, groups, Federated Users, SAML groups and users, QuickSight groups, OUs, and organizations as well as AWS account IDs for cross-account permissions."
  type        = string
}

variable "catalog_resource" {
  description = "Whether the permissions are to be granted for the Data Catalog."
  type        = bool
  default     = false
}

variable "data_cells_filter" {
  description = "Configuration block for a data cells filter resource."
  type = object({
    database_name    = string
    name             = string
    table_catalog_id = string
    table_name       = string
  })
  default = null
}

variable "data_location" {
  description = "Configuration block for a data location resource."
  type = object({
    arn        = string
    catalog_id = optional(string)
  })
  default = null
}

variable "database" {
  description = "Configuration block for a database resource."
  type = object({
    name       = string
    catalog_id = optional(string)
  })
  default = null
}

variable "lf_tag" {
  description = "Configuration block for an LF-tag resource."
  type = object({
    key        = string
    values     = list(string)
    catalog_id = optional(string)
  })
  default = null
}

variable "lf_tag_policy" {
  description = "Configuration block for an LF-tag policy resource."
  type = object({
    resource_type = string
    catalog_id    = optional(string)
    expression = list(object({
      key    = string
      values = list(string)
    }))
  })
  default = null

  validation {
    condition     = var.lf_tag_policy == null || contains(["DATABASE", "TABLE"], var.lf_tag_policy.resource_type)
    error_message = "resource_aws_lakeformation_permissions, lf_tag_policy.resource_type: Valid values are DATABASE and TABLE."
  }
}

variable "table" {
  description = "Configuration block for a table resource."
  type = object({
    database_name = string
    name          = optional(string)
    wildcard      = optional(bool, false)
    region        = optional(string)
    catalog_id    = optional(string)
  })
  default = null

  validation {
    condition     = var.table == null || (var.table.name != null || var.table.wildcard == true)
    error_message = "resource_aws_lakeformation_permissions, table: At least one of name or wildcard is required."
  }
}

variable "table_with_columns" {
  description = "Configuration block for a table with columns resource."
  type = object({
    column_names          = optional(set(string))
    database_name         = string
    name                  = string
    wildcard              = optional(bool, false)
    region                = optional(string)
    catalog_id            = optional(string)
    excluded_column_names = optional(set(string))
  })
  default = null

  validation {
    condition     = var.table_with_columns == null || (var.table_with_columns.column_names != null || var.table_with_columns.wildcard == true)
    error_message = "resource_aws_lakeformation_permissions, table_with_columns: At least one of column_names or wildcard is required."
  }

  validation {
    condition     = var.table_with_columns == null || (var.table_with_columns.excluded_column_names == null || var.table_with_columns.wildcard == true)
    error_message = "resource_aws_lakeformation_permissions, table_with_columns: If excluded_column_names is included, wildcard must be set to true."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "Identifier for the Data Catalog. By default, the account ID. The Data Catalog is the persistent metadata store."
  type        = string
  default     = null
}

variable "permissions_with_grant_option" {
  description = "Subset of permissions which the principal can pass."
  type        = list(string)
  default     = null

  validation {
    condition = var.permissions_with_grant_option == null || alltrue([
      for permission in var.permissions_with_grant_option : contains([
        "ALL", "ALTER", "ASSOCIATE", "CREATE_DATABASE", "CREATE_TABLE",
        "DATA_LOCATION_ACCESS", "DELETE", "DESCRIBE", "DROP", "INSERT", "SELECT"
      ], permission)
    ])
    error_message = "resource_aws_lakeformation_permissions, permissions_with_grant_option: Valid permissions are ALL, ALTER, ASSOCIATE, CREATE_DATABASE, CREATE_TABLE, DATA_LOCATION_ACCESS, DELETE, DESCRIBE, DROP, INSERT, and SELECT."
  }
}