variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "table_name" {
  description = "Name of the table. For Hive compatibility, this must be entirely lowercase."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.table_name))
    error_message = "resource_aws_glue_partition_index, table_name must be entirely lowercase and contain only letters, numbers, and underscores."
  }
}

variable "database_name" {
  description = "Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.database_name))
    error_message = "resource_aws_glue_partition_index, database_name must be all lowercase and contain only letters, numbers, and underscores."
  }
}

variable "catalog_id" {
  description = "The catalog ID where the table resides."
  type        = string
  default     = null
}

variable "partition_index" {
  description = "Configuration block for a partition index."
  type = object({
    index_name = string
    keys       = list(string)
  })

  validation {
    condition     = length(var.partition_index.keys) > 0
    error_message = "resource_aws_glue_partition_index, partition_index keys must contain at least one key."
  }

  validation {
    condition     = length(var.partition_index.index_name) > 0
    error_message = "resource_aws_glue_partition_index, partition_index index_name cannot be empty."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }
}