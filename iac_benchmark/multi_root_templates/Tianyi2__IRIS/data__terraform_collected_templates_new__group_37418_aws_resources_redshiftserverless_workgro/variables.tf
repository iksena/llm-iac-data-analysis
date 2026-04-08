variable "namespace_name" {
  description = "The name of the namespace."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.namespace_name))
    error_message = "resource_aws_redshiftserverless_workgroup, namespace_name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "workgroup_name" {
  description = "The name of the workgroup."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.workgroup_name))
    error_message = "resource_aws_redshiftserverless_workgroup, workgroup_name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "base_capacity" {
  description = "The base data warehouse capacity of the workgroup in Redshift Processing Units (RPUs)."
  type        = number
  default     = null

  validation {
    condition     = var.base_capacity == null || var.base_capacity >= 8
    error_message = "resource_aws_redshiftserverless_workgroup, base_capacity must be at least 8 RPUs when specified."
  }
}

variable "price_performance_target" {
  description = "Price-performance scaling for the workgroup."
  type = object({
    enabled = bool
    level   = number
  })
  default = null

  validation {
    condition = var.price_performance_target == null || (
      var.price_performance_target.enabled != null &&
      contains([1, 25, 50, 75, 100], var.price_performance_target.level)
    )
    error_message = "resource_aws_redshiftserverless_workgroup, price_performance_target level must be one of: 1 (LOW_COST), 25 (ECONOMICAL), 50 (BALANCED), 75 (RESOURCEFUL), 100 (HIGH_PERFORMANCE)."
  }
}

variable "config_parameter" {
  description = "An array of parameters to set for more control over a serverless database."
  type = list(object({
    parameter_key   = string
    parameter_value = string
  }))
  default = null

  validation {
    condition = var.config_parameter == null || alltrue([
      for param in var.config_parameter : contains([
        "auto_mv", "datestyle", "enable_case_sensitive_identifier",
        "enable_user_activity_logging", "query_group", "search_path",
        "require_ssl", "use_fips_ssl", "max_query_cpu_time",
        "max_query_blocks_read", "max_scan_row_count",
        "max_query_execution_time", "max_query_queue_time",
        "max_query_cpu_usage_percent", "max_query_temp_blocks_to_disk",
        "max_join_row_count", "max_nested_loop_join_row_count"
      ], param.parameter_key)
    ])
    error_message = "resource_aws_redshiftserverless_workgroup, config_parameter parameter_key must be one of the supported parameter keys."
  }
}

variable "enhanced_vpc_routing" {
  description = "The value that specifies whether to turn on enhanced virtual private cloud (VPC) routing."
  type        = bool
  default     = null
}

variable "max_capacity" {
  description = "The maximum data-warehouse capacity Amazon Redshift Serverless uses to serve queries, specified in Redshift Processing Units (RPUs)."
  type        = number
  default     = null

  validation {
    condition     = var.max_capacity == null || var.max_capacity >= 8
    error_message = "resource_aws_redshiftserverless_workgroup, max_capacity must be at least 8 RPUs when specified."
  }
}

variable "port" {
  description = "The port number on which the cluster accepts incoming connections."
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1024 && var.port <= 65535)
    error_message = "resource_aws_redshiftserverless_workgroup, port must be between 1024 and 65535."
  }
}

variable "publicly_accessible" {
  description = "A value that specifies whether the workgroup can be accessed from a public network."
  type        = bool
  default     = null
}

variable "security_group_ids" {
  description = "An array of security group IDs to associate with the workgroup."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_ids == null || alltrue([
      for sg_id in var.security_group_ids : can(regex("^sg-[0-9a-f]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_redshiftserverless_workgroup, security_group_ids must be valid security group IDs."
  }
}

variable "subnet_ids" {
  description = "An array of VPC subnet IDs to associate with the workgroup. When set, must contain at least three subnets spanning three Availability Zones."
  type        = list(string)
  default     = null

  validation {
    condition = var.subnet_ids == null || (
      length(var.subnet_ids) >= 3 && alltrue([
        for subnet_id in var.subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", subnet_id))
      ])
    )
    error_message = "resource_aws_redshiftserverless_workgroup, subnet_ids must contain at least three valid subnet IDs when specified."
  }
}

variable "track_name" {
  description = "The name of the track for the workgroup. If it is current, you get the most up-to-date certified release version. If it is trailing, you will be on the previous certified release."
  type        = string
  default     = null

  validation {
    condition     = var.track_name == null || contains(["current", "trailing"], var.track_name)
    error_message = "resource_aws_redshiftserverless_workgroup, track_name must be either 'current' or 'trailing'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}