variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "The amount of storage (in gigabytes) to be initially allocated for the replication instance."
  type        = number
  default     = 50

  validation {
    condition     = var.allocated_storage >= 5 && var.allocated_storage <= 6144
    error_message = "resource_aws_dms_replication_instance, allocated_storage must be between 5 and 6144 gigabytes."
  }
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Indicates whether the changes should be applied immediately or during the next maintenance window. Only used when updating an existing resource."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the replication instance during the maintenance window."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The EC2 Availability Zone that the replication instance will be created in."
  type        = string
  default     = null
}

variable "dns_name_servers" {
  description = "A list of custom DNS name servers supported for the replication instance to access your on-premise source or target database."
  type        = list(string)
  default     = null

  validation {
    condition     = var.dns_name_servers == null ? true : length(var.dns_name_servers) <= 4
    error_message = "resource_aws_dms_replication_instance, dns_name_servers can specify up to four on-premise DNS name servers."
  }
}

variable "engine_version" {
  description = "The engine version number of the replication instance."
  type        = string
  default     = null
}

variable "kerberos_authentication_settings" {
  description = "Configuration block for settings required for Kerberos authentication."
  type = object({
    key_cache_secret_iam_arn = string
    key_cache_secret_id      = string
    krb5_file_contents       = string
  })
  default = null

  validation {
    condition = var.kerberos_authentication_settings == null ? true : (
      var.kerberos_authentication_settings.key_cache_secret_iam_arn != null &&
      var.kerberos_authentication_settings.key_cache_secret_id != null &&
      var.kerberos_authentication_settings.krb5_file_contents != null
    )
    error_message = "resource_aws_dms_replication_instance, kerberos_authentication_settings requires key_cache_secret_iam_arn, key_cache_secret_id, and krb5_file_contents to be specified."
  }
}

variable "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) for the KMS key that will be used to encrypt the connection parameters."
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the replication instance is a multi-az deployment. You cannot set the availability_zone parameter if the multi_az parameter is set to true."
  type        = bool
  default     = null
}

variable "network_type" {
  description = "The type of IP address protocol used by a replication instance."
  type        = string
  default     = null

  validation {
    condition     = var.network_type == null ? true : contains(["IPV4", "DUAL"], var.network_type)
    error_message = "resource_aws_dms_replication_instance, network_type must be either 'IPV4' or 'DUAL'."
  }
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC)."
  type        = string
  default     = null
}

variable "publicly_accessible" {
  description = "Specifies the accessibility options for the replication instance. A value of true represents an instance with a public IP address."
  type        = bool
  default     = false
}

variable "replication_instance_class" {
  description = "The compute and memory capacity of the replication instance as specified by the replication instance class."
  type        = string

  validation {
    condition     = var.replication_instance_class != null && var.replication_instance_class != ""
    error_message = "resource_aws_dms_replication_instance, replication_instance_class is required and cannot be empty."
  }
}

variable "replication_instance_id" {
  description = "The replication instance identifier. This parameter is stored as a lowercase string."
  type        = string

  validation {
    condition     = var.replication_instance_id != null && var.replication_instance_id != ""
    error_message = "resource_aws_dms_replication_instance, replication_instance_id is required and cannot be empty."
  }
}

variable "replication_subnet_group_id" {
  description = "A subnet group to associate with the replication instance."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to be used with the replication instance."
  type        = list(string)
  default     = null
}

variable "timeouts" {
  description = "Configuration block for timeout values."
  type = object({
    create = optional(string, "40m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "40m"
    update = "30m"
    delete = "30m"
  }
}