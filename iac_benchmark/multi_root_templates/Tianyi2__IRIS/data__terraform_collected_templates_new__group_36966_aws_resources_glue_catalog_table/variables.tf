variable "name" {
  description = "Name of the table. For Hive compatibility, this must be entirely lowercase."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.name))
    error_message = "resource_aws_glue_catalog_table, name must be entirely lowercase and contain only letters, numbers, and underscores."
  }
}

variable "database_name" {
  description = "Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.database_name))
    error_message = "resource_aws_glue_catalog_table, database_name must be all lowercase and contain only letters, numbers, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the table."
  type        = string
  default     = null
}

variable "owner" {
  description = "Owner of the table."
  type        = string
  default     = null
}

variable "open_table_format_input" {
  description = "Configuration block for open table formats."
  type = object({
    iceberg_input = object({
      metadata_operation = string
      version            = optional(number, 2)
    })
  })
  default = null

  validation {
    condition = var.open_table_format_input == null || (
      var.open_table_format_input.iceberg_input.metadata_operation == "CREATE"
    )
    error_message = "resource_aws_glue_catalog_table, open_table_format_input.iceberg_input.metadata_operation can only be set to CREATE."
  }
}

variable "parameters" {
  description = "Properties associated with this table, as a list of key-value pairs."
  type        = map(string)
  default     = {}
}

variable "partition_index" {
  description = "Configuration block for a maximum of 3 partition indexes."
  type = list(object({
    index_name = string
    keys       = list(string)
  }))
  default = []

  validation {
    condition     = length(var.partition_index) <= 3
    error_message = "resource_aws_glue_catalog_table, partition_index can have a maximum of 3 partition indexes."
  }
}

variable "partition_keys" {
  description = "Configuration block of columns by which the table is partitioned. Only primitive types are supported as partition keys."
  type = list(object({
    comment    = optional(string)
    name       = string
    parameters = optional(map(string))
    type       = optional(string)
  }))
  default = []
}

variable "retention" {
  description = "Retention time for this table."
  type        = number
  default     = null
}

variable "storage_descriptor" {
  description = "Configuration block for information about the physical storage of this table."
  type = object({
    additional_locations = optional(list(string))
    bucket_columns       = optional(list(string))
    columns = optional(list(object({
      comment    = optional(string)
      name       = string
      parameters = optional(map(string))
      type       = optional(string)
    })))
    compressed        = optional(bool)
    input_format      = optional(string)
    location          = optional(string)
    number_of_buckets = optional(number)
    output_format     = optional(string)
    parameters        = optional(map(string))
    schema_reference = optional(object({
      schema_id = optional(object({
        registry_name = optional(string)
        schema_arn    = optional(string)
        schema_name   = optional(string)
      }))
      schema_version_id     = optional(string)
      schema_version_number = number
    }))
    ser_de_info = optional(object({
      name                  = optional(string)
      parameters            = optional(map(string))
      serialization_library = optional(string)
    }))
    skewed_info = optional(object({
      skewed_column_names               = optional(list(string))
      skewed_column_value_location_maps = optional(map(string))
      skewed_column_values              = optional(list(string))
    }))
    sort_columns = optional(list(object({
      column     = string
      sort_order = number
    })))
    stored_as_sub_directories = optional(bool)
  })
  default = null

  validation {
    condition = var.storage_descriptor == null || var.storage_descriptor.schema_reference == null || (
      (var.storage_descriptor.schema_reference.schema_id != null && var.storage_descriptor.schema_reference.schema_version_id == null) ||
      (var.storage_descriptor.schema_reference.schema_id == null && var.storage_descriptor.schema_reference.schema_version_id != null)
    )
    error_message = "resource_aws_glue_catalog_table, storage_descriptor.schema_reference either schema_id or schema_version_id must be provided, but not both."
  }

  validation {
    condition = var.storage_descriptor == null || var.storage_descriptor.schema_reference == null || var.storage_descriptor.schema_reference.schema_id == null || (
      (var.storage_descriptor.schema_reference.schema_id.schema_arn != null && var.storage_descriptor.schema_reference.schema_id.schema_name == null) ||
      (var.storage_descriptor.schema_reference.schema_id.schema_arn == null && var.storage_descriptor.schema_reference.schema_id.schema_name != null)
    )
    error_message = "resource_aws_glue_catalog_table, storage_descriptor.schema_reference.schema_id one of schema_arn or schema_name must be provided, but not both."
  }

  validation {
    condition     = var.storage_descriptor == null || var.storage_descriptor.schema_reference == null || var.storage_descriptor.schema_reference.schema_id == null || var.storage_descriptor.schema_reference.schema_id.schema_name == null || var.storage_descriptor.schema_reference.schema_id.registry_name != null
    error_message = "resource_aws_glue_catalog_table, storage_descriptor.schema_reference.schema_id registry_name must be provided when schema_name is specified."
  }

  validation {
    condition = var.storage_descriptor == null || var.storage_descriptor.sort_columns == null || alltrue([
      for sort_col in var.storage_descriptor.sort_columns : contains([0, 1], sort_col.sort_order)
    ])
    error_message = "resource_aws_glue_catalog_table, storage_descriptor.sort_columns sort_order must be 0 (descending) or 1 (ascending)."
  }
}

variable "table_type" {
  description = "Type of this table (EXTERNAL_TABLE, VIRTUAL_VIEW, etc.). While optional, some Athena DDL queries such as ALTER TABLE and SHOW CREATE TABLE will fail if this argument is empty."
  type        = string
  default     = null
}

variable "target_table" {
  description = "Configuration block of a target table for resource linking."
  type = object({
    catalog_id    = string
    database_name = string
    name          = string
    region        = optional(string)
  })
  default = null
}

variable "view_expanded_text" {
  description = "If the table is a view, the expanded text of the view; otherwise null."
  type        = string
  default     = null
}

variable "view_original_text" {
  description = "If the table is a view, the original text of the view; otherwise null."
  type        = string
  default     = null
}