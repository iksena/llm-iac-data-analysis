variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "database_name" {
  description = "Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.database_name))
    error_message = "resource_aws_glue_partition, database_name must be all lowercase and contain only letters, numbers, and underscores."
  }
}

variable "table_name" {
  description = "Name of the table."
  type        = string

  validation {
    condition     = length(var.table_name) > 0
    error_message = "resource_aws_glue_partition, table_name cannot be empty."
  }
}

variable "partition_values" {
  description = "The values that define the partition."
  type        = list(string)

  validation {
    condition     = length(var.partition_values) > 0
    error_message = "resource_aws_glue_partition, partition_values must contain at least one value."
  }
}

variable "catalog_id" {
  description = "ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  type        = string
  default     = null
}

variable "parameters" {
  description = "Properties associated with this table, as a list of key-value pairs."
  type        = map(string)
  default     = null
}

variable "storage_descriptor" {
  description = "A storage descriptor object containing information about the physical storage of this table."
  type = object({
    additional_locations      = optional(list(string))
    location                  = optional(string)
    input_format              = optional(string)
    output_format             = optional(string)
    compressed                = optional(bool)
    number_of_buckets         = optional(number)
    bucket_columns            = optional(list(string))
    parameters                = optional(map(string))
    stored_as_sub_directories = optional(bool)

    columns = optional(list(object({
      name    = string
      type    = optional(string)
      comment = optional(string)
    })))

    ser_de_info = optional(object({
      name                  = optional(string)
      parameters            = optional(map(string))
      serialization_library = optional(string)
    }))

    sort_columns = optional(list(object({
      column     = string
      sort_order = number
    })))

    skewed_info = optional(object({
      skewed_column_names               = optional(list(string))
      skewed_column_value_location_maps = optional(list(string))
      skewed_column_values              = optional(map(string))
    }))
  })
  default = null

  validation {
    condition = var.storage_descriptor == null ? true : (
      var.storage_descriptor.sort_columns == null ? true :
      alltrue([
        for sc in var.storage_descriptor.sort_columns :
        contains([0, 1], sc.sort_order)
      ])
    )
    error_message = "resource_aws_glue_partition, storage_descriptor.sort_columns.sort_order must be 0 (descending) or 1 (ascending)."
  }

  validation {
    condition = var.storage_descriptor == null ? true : (
      var.storage_descriptor.columns == null ? true :
      alltrue([
        for col in var.storage_descriptor.columns :
        length(col.name) > 0
      ])
    )
    error_message = "resource_aws_glue_partition, storage_descriptor.columns.name cannot be empty."
  }

  validation {
    condition = var.storage_descriptor == null ? true : (
      var.storage_descriptor.number_of_buckets == null ? true :
      var.storage_descriptor.number_of_buckets >= 0
    )
    error_message = "resource_aws_glue_partition, storage_descriptor.number_of_buckets must be greater than or equal to 0."
  }
}