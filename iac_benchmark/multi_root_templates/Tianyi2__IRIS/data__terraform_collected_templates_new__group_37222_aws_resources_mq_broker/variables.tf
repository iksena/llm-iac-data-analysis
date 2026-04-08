variable "broker_name" {
  description = "Name of the broker"
  type        = string

  validation {
    condition     = length(var.broker_name) > 0
    error_message = "resource_aws_mq_broker, broker_name must not be empty."
  }
}

variable "engine_type" {
  description = "Type of broker engine. Valid values are ActiveMQ and RabbitMQ"
  type        = string

  validation {
    condition     = contains(["ActiveMQ", "RabbitMQ"], var.engine_type)
    error_message = "resource_aws_mq_broker, engine_type must be either 'ActiveMQ' or 'RabbitMQ'."
  }
}

variable "engine_version" {
  description = "Version of the broker engine"
  type        = string

  validation {
    condition     = length(var.engine_version) > 0
    error_message = "resource_aws_mq_broker, engine_version must not be empty."
  }
}

variable "host_instance_type" {
  description = "Broker's instance type. For example, mq.t3.micro, mq.m5.large"
  type        = string

  validation {
    condition     = can(regex("^mq\\.", var.host_instance_type))
    error_message = "resource_aws_mq_broker, host_instance_type must start with 'mq.'."
  }
}

variable "user" {
  description = "Configuration block for broker users"
  type = list(object({
    username         = string
    password         = string
    console_access   = optional(bool)
    groups           = optional(list(string))
    replication_user = optional(bool, false)
  }))

  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_mq_broker, user must contain at least one user configuration."
  }

  validation {
    condition = alltrue([
      for u in var.user : length(u.username) > 0
    ])
    error_message = "resource_aws_mq_broker, user username must not be empty."
  }

  validation {
    condition = alltrue([
      for u in var.user : length(u.password) >= 12 && length(u.password) <= 250
    ])
    error_message = "resource_aws_mq_broker, user password must be 12 to 250 characters long."
  }

  validation {
    condition = alltrue([
      for u in var.user : !strcontains(u.password, ",")
    ])
    error_message = "resource_aws_mq_broker, user password must not contain commas."
  }

  validation {
    condition = alltrue([
      for u in var.user : u.groups == null || length(u.groups) <= 20
    ])
    error_message = "resource_aws_mq_broker, user groups must not exceed 20 groups."
  }
}

variable "apply_immediately" {
  description = "Whether to apply broker modifications immediately"
  type        = bool
  default     = false
}

variable "authentication_strategy" {
  description = "Authentication strategy used to secure the broker. Valid values are simple and ldap"
  type        = string
  default     = null

  validation {
    condition     = var.authentication_strategy == null || contains(["simple", "ldap"], var.authentication_strategy)
    error_message = "resource_aws_mq_broker, authentication_strategy must be either 'simple' or 'ldap'."
  }
}

variable "auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available"
  type        = bool
  default     = null
}

variable "configuration" {
  description = "Configuration block for broker configuration"
  type = object({
    id       = optional(string)
    revision = optional(number)
  })
  default = null
}

variable "data_replication_mode" {
  description = "Whether this broker is part of a data replication pair. Valid values are CRDR and NONE"
  type        = string
  default     = null

  validation {
    condition     = var.data_replication_mode == null || contains(["CRDR", "NONE"], var.data_replication_mode)
    error_message = "resource_aws_mq_broker, data_replication_mode must be either 'CRDR' or 'NONE'."
  }
}

variable "data_replication_primary_broker_arn" {
  description = "ARN of the primary broker used to replicate data in a data replication pair"
  type        = string
  default     = null

  validation {
    condition = var.data_replication_primary_broker_arn == null || (
      var.data_replication_mode == "CRDR" &&
      can(regex("^arn:aws:mq:", var.data_replication_primary_broker_arn))
    )
    error_message = "resource_aws_mq_broker, data_replication_primary_broker_arn is required when data_replication_mode is 'CRDR' and must be a valid ARN."
  }
}

variable "deployment_mode" {
  description = "Deployment mode of the broker. Valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ"
  type        = string
  default     = "SINGLE_INSTANCE"

  validation {
    condition     = contains(["SINGLE_INSTANCE", "ACTIVE_STANDBY_MULTI_AZ", "CLUSTER_MULTI_AZ"], var.deployment_mode)
    error_message = "resource_aws_mq_broker, deployment_mode must be one of 'SINGLE_INSTANCE', 'ACTIVE_STANDBY_MULTI_AZ', or 'CLUSTER_MULTI_AZ'."
  }
}

variable "encryption_options" {
  description = "Configuration block containing encryption options"
  type = object({
    kms_key_id        = optional(string)
    use_aws_owned_key = optional(bool, true)
  })
  default = null

  validation {
    condition = var.encryption_options == null || (
      var.encryption_options.use_aws_owned_key == false ?
      var.encryption_options.kms_key_id != null : true
    )
    error_message = "resource_aws_mq_broker, encryption_options kms_key_id is required when use_aws_owned_key is false."
  }
}

variable "ldap_server_metadata" {
  description = "Configuration block for the LDAP server used to authenticate and authorize connections"
  type = object({
    hosts                    = optional(list(string))
    role_base                = optional(string)
    role_name                = optional(string)
    role_search_matching     = optional(string)
    role_search_subtree      = optional(bool)
    service_account_password = optional(string)
    service_account_username = optional(string)
    user_base                = optional(string)
    user_role_name           = optional(string)
    user_search_matching     = optional(string)
    user_search_subtree      = optional(bool)
  })
  default = null
}

variable "logs" {
  description = "Configuration block for the logging configuration"
  type = object({
    audit   = optional(bool, false)
    general = optional(bool, false)
  })
  default = null
}

variable "maintenance_window_start_time" {
  description = "Configuration block for the maintenance window start time"
  type = object({
    day_of_week = string
    time_of_day = string
    time_zone   = string
  })
  default = null

  validation {
    condition = var.maintenance_window_start_time == null || contains([
      "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    ], var.maintenance_window_start_time.day_of_week)
    error_message = "resource_aws_mq_broker, maintenance_window_start_time day_of_week must be a valid day (MONDAY, TUESDAY, etc.)."
  }

  validation {
    condition     = var.maintenance_window_start_time == null || can(regex("^([0-1][0-9]|2[0-3]):[0-5][0-9]$", var.maintenance_window_start_time.time_of_day))
    error_message = "resource_aws_mq_broker, maintenance_window_start_time time_of_day must be in 24-hour format (HH:MM)."
  }

  validation {
    condition     = var.maintenance_window_start_time == null || length(var.maintenance_window_start_time.time_zone) > 0
    error_message = "resource_aws_mq_broker, maintenance_window_start_time time_zone must not be empty."
  }
}

variable "publicly_accessible" {
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
  type        = bool
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "List of security group IDs assigned to the broker"
  type        = list(string)
  default     = null

  validation {
    condition = var.security_groups == null || alltrue([
      for sg in var.security_groups : can(regex("^sg-", sg))
    ])
    error_message = "resource_aws_mq_broker, security_groups must contain valid security group IDs starting with 'sg-'."
  }
}

variable "storage_type" {
  description = "Storage type of the broker. For ActiveMQ: efs, ebs. For RabbitMQ: ebs only"
  type        = string
  default     = null

  validation {
    condition     = var.storage_type == null || contains(["efs", "ebs"], var.storage_type)
    error_message = "resource_aws_mq_broker, storage_type must be either 'efs' or 'ebs'."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs in which to launch the broker"
  type        = list(string)
  default     = null

  validation {
    condition = var.subnet_ids == null || alltrue([
      for subnet in var.subnet_ids : can(regex("^subnet-", subnet))
    ])
    error_message = "resource_aws_mq_broker, subnet_ids must contain valid subnet IDs starting with 'subnet-'."
  }
}

variable "tags" {
  description = "Map of tags to assign to the broker"
  type        = map(string)
  default     = null
}