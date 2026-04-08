variable "allocated_storage" {
  description = "Amount of storage in GiB (gibibytes). The minimum value is 20, the maximum value is 16384."
  type        = number

  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 16384
    error_message = "resource_aws_timestreaminfluxdb_db_instance, allocated_storage must be between 20 and 16384 GiB."
  }
}

variable "bucket" {
  description = "Name of the initial InfluxDB bucket. All InfluxDB data is stored in a bucket."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_instance, bucket cannot be empty."
  }
}

variable "db_instance_type" {
  description = "Timestream for InfluxDB DB instance type to run InfluxDB on."
  type        = string

  validation {
    condition = contains([
      "db.influx.medium",
      "db.influx.large",
      "db.influx.xlarge",
      "db.influx.2xlarge",
      "db.influx.4xlarge",
      "db.influx.8xlarge",
      "db.influx.12xlarge",
      "db.influx.16xlarge"
    ], var.db_instance_type)
    error_message = "resource_aws_timestreaminfluxdb_db_instance, db_instance_type must be one of: db.influx.medium, db.influx.large, db.influx.xlarge, db.influx.2xlarge, db.influx.4xlarge, db.influx.8xlarge, db.influx.12xlarge, db.influx.16xlarge."
  }
}

variable "name" {
  description = "Name that uniquely identifies the DB instance. Must start with a letter, cannot contain consecutive hyphens and cannot end with a hyphen."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.name)) || can(regex("^[a-zA-Z][a-zA-Z0-9]*$", var.name))
    error_message = "resource_aws_timestreaminfluxdb_db_instance, name must start with a letter, cannot contain consecutive hyphens and cannot end with a hyphen."
  }

  validation {
    condition     = !can(regex("--", var.name))
    error_message = "resource_aws_timestreaminfluxdb_db_instance, name cannot contain consecutive hyphens."
  }
}

variable "password" {
  description = "Password of the initial admin user created in InfluxDB."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.password) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_instance, password cannot be empty."
  }
}

variable "organization" {
  description = "Name of the initial organization for the initial admin user in InfluxDB."
  type        = string

  validation {
    condition     = length(var.organization) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_instance, organization cannot be empty."
  }
}

variable "username" {
  description = "Username of the initial admin user created in InfluxDB. Must start with a letter and can't end with a hyphen or contain two consecutive hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.username)) || can(regex("^[a-zA-Z][a-zA-Z0-9]*$", var.username))
    error_message = "resource_aws_timestreaminfluxdb_db_instance, username must start with a letter and can't end with a hyphen."
  }

  validation {
    condition     = !can(regex("--", var.username))
    error_message = "resource_aws_timestreaminfluxdb_db_instance, username cannot contain two consecutive hyphens."
  }
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with the DB instance."
  type        = list(string)

  validation {
    condition     = length(var.vpc_security_group_ids) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_instance, vpc_security_group_ids must contain at least one security group ID."
  }
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet IDs to associate with the DB instance. Provide at least two VPC subnet IDs in different availability zones when deploying with a Multi-AZ standby."
  type        = list(string)

  validation {
    condition     = length(var.vpc_subnet_ids) >= 1
    error_message = "resource_aws_timestreaminfluxdb_db_instance, vpc_subnet_ids must contain at least one subnet ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_parameter_group_identifier" {
  description = "ID of the DB parameter group assigned to your DB instance."
  type        = string
  default     = null
}

variable "db_storage_type" {
  description = "Timestream for InfluxDB DB storage type to read and write InfluxDB data."
  type        = string
  default     = "InfluxIOIncludedT1"

  validation {
    condition = contains([
      "InfluxIOIncludedT1",
      "InfluxIOIncludedT2",
      "InfluxIOIncludedT3"
    ], var.db_storage_type)
    error_message = "resource_aws_timestreaminfluxdb_db_instance, db_storage_type must be one of: InfluxIOIncludedT1, InfluxIOIncludedT2, InfluxIOIncludedT3."
  }
}

variable "deployment_type" {
  description = "Specifies whether the DB instance will be deployed as a standalone instance or with a Multi-AZ standby for high availability."
  type        = string
  default     = "SINGLE_AZ"

  validation {
    condition = contains([
      "SINGLE_AZ",
      "WITH_MULTIAZ_STANDBY"
    ], var.deployment_type)
    error_message = "resource_aws_timestreaminfluxdb_db_instance, deployment_type must be one of: SINGLE_AZ, WITH_MULTIAZ_STANDBY."
  }
}

variable "log_delivery_configuration" {
  description = "Configuration for sending InfluxDB engine logs to a specified S3 bucket."
  type = object({
    s3_configuration = object({
      bucket_name = string
      enabled     = bool
    })
  })
  default = null

  validation {
    condition = var.log_delivery_configuration == null ? true : (
      var.log_delivery_configuration.s3_configuration.bucket_name != null &&
      length(var.log_delivery_configuration.s3_configuration.bucket_name) > 0
    )
    error_message = "resource_aws_timestreaminfluxdb_db_instance, log_delivery_configuration s3_configuration bucket_name cannot be empty when specified."
  }
}

variable "network_type" {
  description = "Specifies whether the networkType of the Timestream for InfluxDB instance is IPV4 or DUAL."
  type        = string
  default     = null

  validation {
    condition = var.network_type == null ? true : contains([
      "IPV4",
      "DUAL"
    ], var.network_type)
    error_message = "resource_aws_timestreaminfluxdb_db_instance, network_type must be one of: IPV4, DUAL."
  }
}

variable "port" {
  description = "The port on which the instance accepts connections. Valid values: 1024-65535. Cannot be 2375-2376, 7788-7799, 8090, or 51678-51680."
  type        = number
  default     = 8086

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "resource_aws_timestreaminfluxdb_db_instance, port must be between 1024 and 65535."
  }

  validation {
    condition = !(
      (var.port >= 2375 && var.port <= 2376) ||
      (var.port >= 7788 && var.port <= 7799) ||
      var.port == 8090 ||
      (var.port >= 51678 && var.port <= 51680)
    )
    error_message = "resource_aws_timestreaminfluxdb_db_instance, port cannot be 2375-2376, 7788-7799, 8090, or 51678-51680."
  }
}

variable "publicly_accessible" {
  description = "Configures the DB instance with a public IP to facilitate access."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}