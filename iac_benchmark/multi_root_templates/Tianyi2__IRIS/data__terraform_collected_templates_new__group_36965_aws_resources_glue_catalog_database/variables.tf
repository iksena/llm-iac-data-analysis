variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "ID of the Glue Catalog to create the database in"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the database"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.name))
    error_message = "resource_aws_glue_catalog_database, name must contain only lowercase letters, numbers, and underscore characters."
  }
}

variable "description" {
  description = "Description of the database"
  type        = string
  default     = null
}

variable "location_uri" {
  description = "Location of the database (for example, an HDFS path)"
  type        = string
  default     = null
}

variable "parameters" {
  description = "List of key-value pairs that define parameters and properties of the database"
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "create_table_default_permission" {
  description = "Configuration block for default table permissions"
  type = object({
    permissions = optional(list(string))
    principal = optional(object({
      data_lake_principal_identifier = optional(string)
    }))
  })
  default = null
}

variable "federated_database" {
  description = "Configuration block that references an entity outside the AWS Glue Data Catalog"
  type = object({
    connection_name = optional(string)
    identifier      = optional(string)
  })
  default = null
}

variable "target_database" {
  description = "Configuration block for a target database for resource linking"
  type = object({
    catalog_id    = string
    database_name = string
    region        = optional(string)
  })
  default = null

  validation {
    condition     = var.target_database == null || (var.target_database.catalog_id != null && var.target_database.database_name != null)
    error_message = "resource_aws_glue_catalog_database, target_database requires both catalog_id and database_name when specified."
  }
}