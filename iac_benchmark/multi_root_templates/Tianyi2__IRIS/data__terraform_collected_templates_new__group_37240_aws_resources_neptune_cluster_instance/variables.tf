variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any instance modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the instance during the maintenance window"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "The EC2 Availability Zone that the neptune instance is created in"
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The identifier of the aws_neptune_cluster in which to launch this instance"
  type        = string

  validation {
    condition     = length(var.cluster_identifier) > 0
    error_message = "resource_aws_neptune_cluster_instance, cluster_identifier must not be empty."
  }
}

variable "engine" {
  description = "The name of the database engine to be used for the neptune instance"
  type        = string
  default     = "neptune"

  validation {
    condition     = var.engine == "neptune"
    error_message = "resource_aws_neptune_cluster_instance, engine must be 'neptune'."
  }
}

variable "engine_version" {
  description = "The neptune engine version"
  type        = string
  default     = null
}

variable "identifier" {
  description = "The identifier for the neptune instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = null
}

variable "identifier_prefix" {
  description = "Creates a unique identifier beginning with the specified prefix. Conflicts with identifier"
  type        = string
  default     = null

  validation {
    condition     = var.identifier_prefix == null || var.identifier == null
    error_message = "resource_aws_neptune_cluster_instance, identifier_prefix conflicts with identifier - only one can be specified."
  }
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string

  validation {
    condition     = length(var.instance_class) > 0
    error_message = "resource_aws_neptune_cluster_instance, instance_class must not be empty."
  }
}

variable "neptune_subnet_group_name" {
  description = "A subnet group to associate with this neptune instance. Required if publicly_accessible = false"
  type        = string
  default     = null
}

variable "neptune_parameter_group_name" {
  description = "The name of the neptune parameter group to associate with this instance"
  type        = string
  default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 8182

  validation {
    condition     = var.port > 0 && var.port <= 65535
    error_message = "resource_aws_neptune_cluster_instance, port must be between 1 and 65535."
  }
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  type        = string
  default     = null

  validation {
    condition     = var.preferred_backup_window == null || can(regex("^([0-1][0-9]|2[0-3]):[0-5][0-9]-([0-1][0-9]|2[0-3]):[0-5][0-9]$", var.preferred_backup_window))
    error_message = "resource_aws_neptune_cluster_instance, preferred_backup_window must be in the format 'HH:MM-HH:MM'."
  }
}

variable "preferred_maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = null

  validation {
    condition     = var.preferred_maintenance_window == null || can(regex("^(sun|mon|tue|wed|thu|fri|sat):([0-1][0-9]|2[0-3]):[0-5][0-9]-(sun|mon|tue|wed|thu|fri|sat):([0-1][0-9]|2[0-3]):[0-5][0-9]$", lower(var.preferred_maintenance_window)))
    error_message = "resource_aws_neptune_cluster_instance, preferred_maintenance_window must be in the format 'ddd:hh24:mi-ddd:hh24:mi'."
  }
}

variable "promotion_tier" {
  description = "Default 0. Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoter to writer"
  type        = number
  default     = 0

  validation {
    condition     = var.promotion_tier >= 0 && var.promotion_tier <= 15
    error_message = "resource_aws_neptune_cluster_instance, promotion_tier must be between 0 and 15."
  }
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default     = {}
}