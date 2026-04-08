variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_proxy_name" {
  description = "Name of the RDS DB Proxy."
  type        = string

  validation {
    condition     = length(var.db_proxy_name) > 0
    error_message = "resource_aws_db_proxy_default_target_group, db_proxy_name cannot be empty."
  }
}

variable "connection_pool_config" {
  description = "The settings that determine the size and behavior of the connection pool for the target group."
  type = object({
    connection_borrow_timeout    = optional(number)
    init_query                   = optional(string)
    max_connections_percent      = optional(number)
    max_idle_connections_percent = optional(number)
    session_pinning_filters      = optional(list(string))
  })
  default = null

  validation {
    condition = var.connection_pool_config == null || (
      var.connection_pool_config.connection_borrow_timeout == null ||
      var.connection_pool_config.connection_borrow_timeout >= 1
    )
    error_message = "resource_aws_db_proxy_default_target_group, connection_borrow_timeout must be greater than or equal to 1 second."
  }

  validation {
    condition = var.connection_pool_config == null || (
      var.connection_pool_config.max_connections_percent == null ||
      (var.connection_pool_config.max_connections_percent >= 1 && var.connection_pool_config.max_connections_percent <= 100)
    )
    error_message = "resource_aws_db_proxy_default_target_group, max_connections_percent must be between 1 and 100."
  }

  validation {
    condition = var.connection_pool_config == null || (
      var.connection_pool_config.max_idle_connections_percent == null ||
      (var.connection_pool_config.max_idle_connections_percent >= 0 && var.connection_pool_config.max_idle_connections_percent <= 100)
    )
    error_message = "resource_aws_db_proxy_default_target_group, max_idle_connections_percent must be between 0 and 100."
  }

  validation {
    condition = var.connection_pool_config == null || (
      var.connection_pool_config.session_pinning_filters == null ||
      alltrue([
        for filter in var.connection_pool_config.session_pinning_filters :
        contains(["EXCLUDE_VARIABLE_SETS"], filter)
      ])
    )
    error_message = "resource_aws_db_proxy_default_target_group, session_pinning_filters can only contain 'EXCLUDE_VARIABLE_SETS'."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeouts_create))
    error_message = "resource_aws_db_proxy_default_target_group, timeouts_create must be a valid timeout string (e.g., '30m', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeouts_update))
    error_message = "resource_aws_db_proxy_default_target_group, timeouts_update must be a valid timeout string (e.g., '30m', '1h')."
  }
}