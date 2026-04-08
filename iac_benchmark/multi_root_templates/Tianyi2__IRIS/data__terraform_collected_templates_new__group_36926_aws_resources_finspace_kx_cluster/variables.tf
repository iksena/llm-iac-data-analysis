variable "az_mode" {
  description = "The number of availability zones you want to assign per cluster"
  type        = string
  validation {
    condition     = contains(["SINGLE", "MULTI"], var.az_mode)
    error_message = "resource_aws_finspace_kx_cluster, az_mode must be one of: SINGLE, MULTI."
  }
}

variable "capacity_configuration" {
  description = "Structure for the metadata of a cluster. Includes information like the CPUs needed, memory of instances, and number of instances"
  type = object({
    node_type  = string
    node_count = number
  })
  validation {
    condition = contains([
      "kx.s.large", "kx.s.xlarge", "kx.s.2xlarge", "kx.s.4xlarge",
      "kx.s.8xlarge", "kx.s.16xlarge", "kx.s.32xlarge"
    ], var.capacity_configuration.node_type)
    error_message = "resource_aws_finspace_kx_cluster, capacity_configuration.node_type must be one of: kx.s.large, kx.s.xlarge, kx.s.2xlarge, kx.s.4xlarge, kx.s.8xlarge, kx.s.16xlarge, kx.s.32xlarge."
  }
  validation {
    condition     = var.capacity_configuration.node_count >= 1 && var.capacity_configuration.node_count <= 5
    error_message = "resource_aws_finspace_kx_cluster, capacity_configuration.node_count must be at least 1 and at most 5."
  }
}

variable "environment_id" {
  description = "Unique identifier for the KX environment"
  type        = string
}

variable "name" {
  description = "Unique name for the cluster that you want to create"
  type        = string
}

variable "release_label" {
  description = "Version of FinSpace Managed kdb to run"
  type        = string
}

variable "type" {
  description = "Type of KDB database"
  type        = string
  validation {
    condition     = contains(["HDB", "RDB", "GATEWAY", "GP", "Tickerplant"], var.type)
    error_message = "resource_aws_finspace_kx_cluster, type must be one of: HDB, RDB, GATEWAY, GP, Tickerplant."
  }
}

variable "vpc_configuration" {
  description = "Configuration details about the network where the Privatelink endpoint of the cluster resides"
  type = object({
    vpc_id             = string
    security_group_ids = list(string)
    subnet_ids         = list(string)
    ip_address_type    = string
  })
  validation {
    condition     = var.vpc_configuration.ip_address_type == "IP_V4"
    error_message = "resource_aws_finspace_kx_cluster, vpc_configuration.ip_address_type must be IP_V4."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "auto_scaling_configuration" {
  description = "Configuration based on which FinSpace will scale in or scale out nodes in your cluster"
  type = object({
    auto_scaling_metric        = string
    min_node_count             = number
    max_node_count             = number
    metric_target              = number
    scale_in_cooldown_seconds  = number
    scale_out_cooldown_seconds = number
  })
  default = null
  validation {
    condition = var.auto_scaling_configuration == null || (
      var.auto_scaling_configuration.min_node_count >= 1 &&
      var.auto_scaling_configuration.min_node_count < var.auto_scaling_configuration.max_node_count
    )
    error_message = "resource_aws_finspace_kx_cluster, auto_scaling_configuration.min_node_count must be at least 1 and less than max_node_count."
  }
  validation {
    condition = var.auto_scaling_configuration == null || (
      var.auto_scaling_configuration.max_node_count <= 5
    )
    error_message = "resource_aws_finspace_kx_cluster, auto_scaling_configuration.max_node_count cannot be greater than 5."
  }
  validation {
    condition = var.auto_scaling_configuration == null || (
      var.auto_scaling_configuration.metric_target >= 0 && var.auto_scaling_configuration.metric_target <= 100
    )
    error_message = "resource_aws_finspace_kx_cluster, auto_scaling_configuration.metric_target can be set between 0 and 100 percent."
  }
}

variable "availability_zone_id" {
  description = "The availability zone identifiers for the requested regions. Required when az_mode is set to SINGLE"
  type        = string
  default     = null
}

variable "cache_storage_configurations" {
  description = "Configurations for a read only cache storage associated with a cluster"
  type = list(object({
    type = string
    size = number
  }))
  default = null
  validation {
    condition = var.cache_storage_configurations == null || alltrue([
      for config in var.cache_storage_configurations :
      contains(["CACHE_1000", "CACHE_250", "CACHE_12"], config.type)
    ])
    error_message = "resource_aws_finspace_kx_cluster, cache_storage_configurations.type must be one of: CACHE_1000, CACHE_250, CACHE_12."
  }
}

variable "code" {
  description = "Details of the custom code that you want to use inside a cluster when analyzing data"
  type = object({
    s3_bucket         = string
    s3_key            = string
    s3_object_version = optional(string)
  })
  default = null
}

variable "command_line_arguments" {
  description = "Key-value pairs to make available inside the cluster"
  type        = map(string)
  default     = null
}

variable "database" {
  description = "KX database that will be available for querying"
  type = list(object({
    database_name = string
    changeset_id  = optional(string)
    dataview_name = optional(string)
    cache_configurations = optional(list(object({
      cache_type = string
      db_paths   = optional(string)
    })))
  }))
  default = null
}

variable "description" {
  description = "Description of the cluster"
  type        = string
  default     = null
}

variable "execution_role" {
  description = "An IAM role that defines a set of permissions associated with a cluster"
  type        = string
  default     = null
}

variable "initialization_script" {
  description = "Path to Q program that will be run at launch of a cluster"
  type        = string
  default     = null
}

variable "savedown_storage_configuration" {
  description = "Size and type of the temporary storage that is used to hold data during the savedown process"
  type = object({
    type        = optional(string)
    size        = optional(number)
    volume_name = optional(string)
  })
  default = null
  validation {
    condition = var.savedown_storage_configuration == null || (
      var.savedown_storage_configuration.type == null || var.savedown_storage_configuration.type == "SDS01"
    )
    error_message = "resource_aws_finspace_kx_cluster, savedown_storage_configuration.type must be SDS01."
  }
  validation {
    condition = var.savedown_storage_configuration == null || (
      var.savedown_storage_configuration.size == null ||
      (var.savedown_storage_configuration.size >= 10 && var.savedown_storage_configuration.size <= 16000)
    )
    error_message = "resource_aws_finspace_kx_cluster, savedown_storage_configuration.size must be between 10 and 16000."
  }
}

variable "scaling_group_configuration" {
  description = "The structure that stores the configuration details of a scaling group"
  type = object({
    scaling_group_name = string
    memory_reservation = number
    node_count         = number
    cpu                = optional(number)
    memory_limit       = optional(number)
  })
  default = null
}

variable "tickerplant_log_configuration" {
  description = "A configuration to store Tickerplant logs"
  type = object({
    tickerplant_log_volumes = list(string)
  })
  default = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for operation timeouts"
  type = object({
    create = optional(string, "4h")
    update = optional(string, "4h")
    delete = optional(string, "60m")
  })
  default = null
}