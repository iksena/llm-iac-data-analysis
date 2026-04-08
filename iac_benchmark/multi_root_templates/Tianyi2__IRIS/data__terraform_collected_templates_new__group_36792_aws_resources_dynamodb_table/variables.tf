variable "name" {
  description = "Unique within a region name of the table"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_dynamodb_table, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "hash_key" {
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string

  validation {
    condition     = length(var.hash_key) > 0
    error_message = "resource_aws_dynamodb_table, hash_key must not be empty."
  }
}

variable "attributes" {
  description = "Set of nested attribute definitions. Only required for hash_key and range_key attributes"
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition     = length(var.attributes) > 0
    error_message = "resource_aws_dynamodb_table, attributes must contain at least one attribute."
  }

  validation {
    condition = alltrue([
      for attr in var.attributes : contains(["S", "N", "B"], attr.type)
    ])
    error_message = "resource_aws_dynamodb_table, attributes type must be one of S, N, or B."
  }

  validation {
    condition = alltrue([
      for attr in var.attributes : length(attr.name) > 0
    ])
    error_message = "resource_aws_dynamodb_table, attributes name must not be empty."
  }
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity. Valid values are PROVISIONED and PAY_PER_REQUEST"
  type        = string
  default     = "PROVISIONED"

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "resource_aws_dynamodb_table, billing_mode must be either PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "range_key" {
  description = "Attribute to use as the range (sort) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "Number of read units for this table. Required if billing_mode is PROVISIONED"
  type        = number
  default     = null

  validation {
    condition     = var.read_capacity == null || var.read_capacity >= 1
    error_message = "resource_aws_dynamodb_table, read_capacity must be at least 1 when specified."
  }
}

variable "write_capacity" {
  description = "Number of write units for this table. Required if billing_mode is PROVISIONED"
  type        = number
  default     = null

  validation {
    condition     = var.write_capacity == null || var.write_capacity >= 1
    error_message = "resource_aws_dynamodb_table, write_capacity must be at least 1 when specified."
  }
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table"
  type        = bool
  default     = false
}

variable "stream_enabled" {
  description = "Whether Streams are enabled"
  type        = bool
  default     = null
}

variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream"
  type        = string
  default     = null

  validation {
    condition     = var.stream_view_type == null || contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    error_message = "resource_aws_dynamodb_table, stream_view_type must be one of KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES."
  }
}

variable "table_class" {
  description = "Storage class of the table. Valid values are STANDARD and STANDARD_INFREQUENT_ACCESS"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "resource_aws_dynamodb_table, table_class must be either STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "restore_date_time" {
  description = "Time of the point-in-time recovery point to restore"
  type        = string
  default     = null
}

variable "restore_source_name" {
  description = "Name of the table to restore. Must match the name of an existing table"
  type        = string
  default     = null
}

variable "restore_source_table_arn" {
  description = "ARN of the source table to restore. Must be supplied for cross-region restores"
  type        = string
  default     = null
}

variable "restore_to_latest_time" {
  description = "If set, restores table to the most recent point-in-time recovery point"
  type        = bool
  default     = null
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string))
    read_capacity      = optional(number)
    write_capacity     = optional(number)
    on_demand_throughput = optional(object({
      max_read_request_units  = optional(number)
      max_write_request_units = optional(number)
    }))
    warm_throughput = optional(object({
      read_units_per_second  = optional(number)
      write_units_per_second = optional(number)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : contains(["ALL", "INCLUDE", "KEYS_ONLY"], gsi.projection_type)
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes projection_type must be one of ALL, INCLUDE, or KEYS_ONLY."
  }

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : length(gsi.name) > 0
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes name must not be empty."
  }

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : length(gsi.hash_key) > 0
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes hash_key must not be empty."
  }

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : gsi.on_demand_throughput == null || (
        gsi.on_demand_throughput.max_read_request_units == null ||
        gsi.on_demand_throughput.max_read_request_units >= 1 ||
        gsi.on_demand_throughput.max_read_request_units == -1
      )
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes on_demand_throughput max_read_request_units must be >= 1 or -1 to remove."
  }

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : gsi.on_demand_throughput == null || (
        gsi.on_demand_throughput.max_write_request_units == null ||
        gsi.on_demand_throughput.max_write_request_units >= 1 ||
        gsi.on_demand_throughput.max_write_request_units == -1
      )
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes on_demand_throughput max_write_request_units must be >= 1 or -1 to remove."
  }

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : gsi.warm_throughput == null || (
        gsi.warm_throughput.read_units_per_second == null ||
        gsi.warm_throughput.read_units_per_second >= 12000
      )
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes warm_throughput read_units_per_second must be at least 12000 when specified."
  }

  validation {
    condition = alltrue([
      for gsi in var.global_secondary_indexes : gsi.warm_throughput == null || (
        gsi.warm_throughput.write_units_per_second == null ||
        gsi.warm_throughput.write_units_per_second >= 4000
      )
    ])
    error_message = "resource_aws_dynamodb_table, global_secondary_indexes warm_throughput write_units_per_second must be at least 4000 when specified."
  }
}

variable "local_secondary_indexes" {
  description = "Describe an LSI on the table"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for lsi in var.local_secondary_indexes : contains(["ALL", "INCLUDE", "KEYS_ONLY"], lsi.projection_type)
    ])
    error_message = "resource_aws_dynamodb_table, local_secondary_indexes projection_type must be one of ALL, INCLUDE, or KEYS_ONLY."
  }

  validation {
    condition = alltrue([
      for lsi in var.local_secondary_indexes : length(lsi.name) > 0
    ])
    error_message = "resource_aws_dynamodb_table, local_secondary_indexes name must not be empty."
  }

  validation {
    condition = alltrue([
      for lsi in var.local_secondary_indexes : length(lsi.range_key) > 0
    ])
    error_message = "resource_aws_dynamodb_table, local_secondary_indexes range_key must not be empty."
  }
}

variable "on_demand_throughput" {
  description = "Sets the maximum number of read and write units for the specified on-demand table"
  type = object({
    max_read_request_units  = optional(number)
    max_write_request_units = optional(number)
  })
  default = null

  validation {
    condition = var.on_demand_throughput == null || (
      var.on_demand_throughput.max_read_request_units == null ||
      var.on_demand_throughput.max_read_request_units >= 1 ||
      var.on_demand_throughput.max_read_request_units == -1
    )
    error_message = "resource_aws_dynamodb_table, on_demand_throughput max_read_request_units must be >= 1 or -1 to remove."
  }

  validation {
    condition = var.on_demand_throughput == null || (
      var.on_demand_throughput.max_write_request_units == null ||
      var.on_demand_throughput.max_write_request_units >= 1 ||
      var.on_demand_throughput.max_write_request_units == -1
    )
    error_message = "resource_aws_dynamodb_table, on_demand_throughput max_write_request_units must be >= 1 or -1 to remove."
  }
}

variable "point_in_time_recovery" {
  description = "Enable point-in-time recovery options"
  type = object({
    enabled                 = bool
    recovery_period_in_days = optional(number)
  })
  default = null

  validation {
    condition = var.point_in_time_recovery == null || (
      var.point_in_time_recovery.recovery_period_in_days == null ||
      var.point_in_time_recovery.recovery_period_in_days >= 1
    )
    error_message = "resource_aws_dynamodb_table, point_in_time_recovery recovery_period_in_days must be at least 1 when specified."
  }
}

variable "replicas" {
  description = "Configuration blocks with DynamoDB Global Tables V2 replication configurations"
  type = list(object({
    region_name                 = string
    consistency_mode            = optional(string)
    kms_key_arn                 = optional(string)
    point_in_time_recovery      = optional(bool)
    deletion_protection_enabled = optional(bool)
    propagate_tags              = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for replica in var.replicas : length(replica.region_name) > 0
    ])
    error_message = "resource_aws_dynamodb_table, replicas region_name must not be empty."
  }

  validation {
    condition = alltrue([
      for replica in var.replicas : replica.consistency_mode == null || contains(["STRONG", "EVENTUAL"], replica.consistency_mode)
    ])
    error_message = "resource_aws_dynamodb_table, replicas consistency_mode must be either STRONG or EVENTUAL."
  }
}

variable "server_side_encryption" {
  description = "Encryption at rest options"
  type = object({
    enabled     = bool
    kms_key_arn = optional(string)
  })
  default = null
}

variable "ttl" {
  description = "Configuration block for TTL"
  type = object({
    attribute_name = optional(string)
    enabled        = optional(bool)
  })
  default = null

  validation {
    condition = var.ttl == null || (
      var.ttl.enabled == false || var.ttl.attribute_name != null
    )
    error_message = "resource_aws_dynamodb_table, ttl attribute_name is required when enabled is true."
  }
}

variable "import_table" {
  description = "Import Amazon S3 data into a new table"
  type = object({
    input_compression_type = optional(string)
    input_format           = string
    input_format_options = optional(object({
      csv = optional(object({
        delimiter   = optional(string)
        header_list = optional(list(string))
      }))
    }))
    s3_bucket_source = object({
      bucket       = string
      bucket_owner = optional(string)
      key_prefix   = optional(string)
    })
  })
  default = null

  validation {
    condition     = var.import_table == null || contains(["CSV", "DYNAMODB_JSON", "ION"], var.import_table.input_format)
    error_message = "resource_aws_dynamodb_table, import_table input_format must be one of CSV, DYNAMODB_JSON, or ION."
  }

  validation {
    condition = var.import_table == null || (
      var.import_table.input_compression_type == null ||
      contains(["GZIP", "ZSTD", "NONE"], var.import_table.input_compression_type)
    )
    error_message = "resource_aws_dynamodb_table, import_table input_compression_type must be one of GZIP, ZSTD, or NONE."
  }

  validation {
    condition     = var.import_table == null || length(var.import_table.s3_bucket_source.bucket) > 0
    error_message = "resource_aws_dynamodb_table, import_table s3_bucket_source bucket must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to populate on the created table"
  type        = map(string)
  default     = {}
}

variable "warm_throughput" {
  description = "Sets the number of warm read and write units for the specified table"
  type = object({
    read_units_per_second  = optional(number)
    write_units_per_second = optional(number)
  })
  default = null

  validation {
    condition = var.warm_throughput == null || (
      var.warm_throughput.read_units_per_second == null ||
      var.warm_throughput.read_units_per_second >= 12000
    )
    error_message = "resource_aws_dynamodb_table, warm_throughput read_units_per_second must be at least 12000 when specified."
  }

  validation {
    condition = var.warm_throughput == null || (
      var.warm_throughput.write_units_per_second == null ||
      var.warm_throughput.write_units_per_second >= 4000
    )
    error_message = "resource_aws_dynamodb_table, warm_throughput write_units_per_second must be at least 4000 when specified."
  }
}

variable "timeouts" {
  description = "Timeout configuration for create, update, and delete operations"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "60m")
    delete = optional(string, "10m")
  })
  default = {}
}