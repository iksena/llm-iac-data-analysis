variable "keyspace_name" {
  description = "The name of the keyspace that the table is going to be created in."
  type        = string
}

variable "table_name" {
  description = "The name of the table."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "capacity_specification" {
  description = "Specifies the read/write throughput capacity mode for the table."
  type = object({
    read_capacity_units  = optional(number)
    throughput_mode      = optional(string, "PAY_PER_REQUEST")
    write_capacity_units = optional(number)
  })
  default = null

  validation {
    condition = var.capacity_specification == null || (
      var.capacity_specification.throughput_mode == null ||
      contains(["PAY_PER_REQUEST", "PROVISIONED"], var.capacity_specification.throughput_mode)
    )
    error_message = "resource_aws_keyspaces_table, capacity_specification.throughput_mode must be one of: PAY_PER_REQUEST, PROVISIONED."
  }
}

variable "client_side_timestamps" {
  description = "Enables client-side timestamps for the table. By default, the setting is disabled."
  type = object({
    status = string
  })
  default = null

  validation {
    condition = var.client_side_timestamps == null || (
      var.client_side_timestamps.status == "ENABLED"
    )
    error_message = "resource_aws_keyspaces_table, client_side_timestamps.status must be: ENABLED."
  }
}

variable "comment" {
  description = "A description of the table."
  type = object({
    message = string
  })
  default = null
}

variable "default_time_to_live" {
  description = "The default Time to Live setting in seconds for the table."
  type        = number
  default     = null
}

variable "encryption_specification" {
  description = "Specifies how the encryption key for encryption at rest is managed for the table."
  type = object({
    kms_key_identifier = optional(string)
    type               = optional(string, "AWS_OWNED_KMS_KEY")
  })
  default = null

  validation {
    condition = var.encryption_specification == null || (
      var.encryption_specification.type == null ||
      contains(["AWS_OWNED_KMS_KEY", "CUSTOMER_MANAGED_KMS_KEY"], var.encryption_specification.type)
    )
    error_message = "resource_aws_keyspaces_table, encryption_specification.type must be one of: AWS_OWNED_KMS_KEY, CUSTOMER_MANAGED_KMS_KEY."
  }
}

variable "point_in_time_recovery" {
  description = "Specifies if point-in-time recovery is enabled or disabled for the table."
  type = object({
    status = optional(string, "DISABLED")
  })
  default = null

  validation {
    condition = var.point_in_time_recovery == null || (
      var.point_in_time_recovery.status == null ||
      contains(["ENABLED", "DISABLED"], var.point_in_time_recovery.status)
    )
    error_message = "resource_aws_keyspaces_table, point_in_time_recovery.status must be one of: ENABLED, DISABLED."
  }
}

variable "schema_definition" {
  description = "Describes the schema of the table."
  type = object({
    column = list(object({
      name = string
      type = string
    }))
    partition_key = list(object({
      name = string
    }))
    clustering_key = optional(list(object({
      name     = string
      order_by = string
    })), [])
    static_column = optional(list(object({
      name = string
    })), [])
  })
  default = null

  validation {
    condition = var.schema_definition == null || (
      var.schema_definition.clustering_key == null ||
      alltrue([
        for ck in var.schema_definition.clustering_key :
        contains(["ASC", "DESC"], ck.order_by)
      ])
    )
    error_message = "resource_aws_keyspaces_table, schema_definition.clustering_key.order_by must be one of: ASC, DESC."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "ttl" {
  description = "Enables Time to Live custom settings for the table."
  type = object({
    status = string
  })
  default = null

  validation {
    condition = var.ttl == null || (
      var.ttl.status == "ENABLED"
    )
    error_message = "resource_aws_keyspaces_table, ttl.status must be: ENABLED."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "30m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "30m"
    delete = "10m"
  }
}