variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "compute_config" {
  description = "Configuration block for provisioning an DMS Serverless replication"
  type = object({
    availability_zone            = optional(string)
    dns_name_servers             = optional(list(string))
    kms_key_id                   = optional(string)
    max_capacity_units           = string
    min_capacity_units           = optional(string)
    multi_az                     = optional(bool)
    preferred_maintenance_window = optional(string)
    replication_subnet_group_id  = optional(string)
    vpc_security_group_ids       = optional(list(string))
  })

  validation {
    condition     = contains(["1", "2", "4", "8", "16", "32", "64", "128", "192", "256", "384"], var.compute_config.max_capacity_units)
    error_message = "resource_aws_dms_replication_config, max_capacity_units must be one of: 1, 2, 4, 8, 16, 32, 64, 128, 192, 256, 384."
  }

  validation {
    condition     = var.compute_config.min_capacity_units == null || contains(["1", "2", "4", "8", "16", "32", "64", "128", "192", "256", "384"], var.compute_config.min_capacity_units)
    error_message = "resource_aws_dms_replication_config, min_capacity_units must be one of: 1, 2, 4, 8, 16, 32, 64, 128, 192, 256, 384."
  }

  validation {
    condition     = var.compute_config.preferred_maintenance_window == null || can(regex("^(mon|tue|wed|thu|fri|sat|sun):[0-2][0-9]:[0-5][0-9]-(mon|tue|wed|thu|fri|sat|sun):[0-2][0-9]:[0-5][0-9]$", var.compute_config.preferred_maintenance_window))
    error_message = "resource_aws_dms_replication_config, preferred_maintenance_window must be in format ddd:hh24:mi-ddd:hh24:mi with valid days (mon, tue, wed, thu, fri, sat, sun)."
  }

  validation {
    condition     = var.compute_config.multi_az == null || var.compute_config.availability_zone == null || !var.compute_config.multi_az
    error_message = "resource_aws_dms_replication_config, availability_zone parameter cannot be set if multi_az parameter is set to true."
  }
}

variable "start_replication" {
  description = "Whether to run or stop the serverless replication"
  type        = bool
  default     = false
}

variable "replication_config_identifier" {
  description = "Unique identifier that you want to use to create the config"
  type        = string

  validation {
    condition     = length(var.replication_config_identifier) > 0
    error_message = "resource_aws_dms_replication_config, replication_config_identifier cannot be empty."
  }
}

variable "replication_type" {
  description = "The migration type"
  type        = string

  validation {
    condition     = contains(["full-load", "cdc", "full-load-and-cdc"], var.replication_type)
    error_message = "resource_aws_dms_replication_config, replication_type must be one of: full-load, cdc, full-load-and-cdc."
  }
}

variable "source_endpoint_arn" {
  description = "The Amazon Resource Name (ARN) string that uniquely identifies the source endpoint"
  type        = string

  validation {
    condition     = length(var.source_endpoint_arn) > 0 && can(regex("^arn:aws:dms:", var.source_endpoint_arn))
    error_message = "resource_aws_dms_replication_config, source_endpoint_arn must be a valid DMS endpoint ARN."
  }
}

variable "table_mappings" {
  description = "An escaped JSON string that contains the table mappings"
  type        = string

  validation {
    condition     = length(var.table_mappings) > 0 && can(jsondecode(var.table_mappings))
    error_message = "resource_aws_dms_replication_config, table_mappings must be a valid JSON string."
  }
}

variable "target_endpoint_arn" {
  description = "The Amazon Resource Name (ARN) string that uniquely identifies the target endpoint"
  type        = string

  validation {
    condition     = length(var.target_endpoint_arn) > 0 && can(regex("^arn:aws:dms:", var.target_endpoint_arn))
    error_message = "resource_aws_dms_replication_config, target_endpoint_arn must be a valid DMS endpoint ARN."
  }
}

variable "replication_settings" {
  description = "An escaped JSON string that are used to provision this replication configuration"
  type        = string
  default     = null

  validation {
    condition     = var.replication_settings == null || can(jsondecode(var.replication_settings))
    error_message = "resource_aws_dms_replication_config, replication_settings must be a valid JSON string."
  }
}

variable "resource_identifier" {
  description = "Unique value or name that you set for a given resource that can be used to construct an Amazon Resource Name (ARN) for that resource"
  type        = string
  default     = null
}

variable "supplemental_settings" {
  description = "JSON settings for specifying supplemental data"
  type        = string
  default     = null

  validation {
    condition     = var.supplemental_settings == null || can(jsondecode(var.supplemental_settings))
    error_message = "resource_aws_dms_replication_config, supplemental_settings must be a valid JSON string."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}