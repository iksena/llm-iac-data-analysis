variable "allocated_storage" {
  description = "Amount of storage in GiB (gibibytes). The minimum value is 20, the maximum value is 16384"
  type        = number
  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 16384
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, allocated_storage must be between 20 and 16384 GiB"
  }
}

variable "bucket" {
  description = "Name of the initial InfluxDB bucket"
  type        = string
  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, bucket cannot be empty"
  }
}

variable "db_instance_type" {
  description = "Timestream for InfluxDB DB instance type to run InfluxDB on"
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
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, db_instance_type must be one of: db.influx.medium, db.influx.large, db.influx.xlarge, db.influx.2xlarge, db.influx.4xlarge, db.influx.8xlarge, db.influx.12xlarge, db.influx.16xlarge"
  }
}

variable "name" {
  description = "Name that uniquely identifies the DB cluster"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z]", var.name)) && can(regex("[^-]$", var.name)) && !can(regex("--", var.name))
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, name must start with a letter, cannot contain consecutive hyphens and cannot end with a hyphen"
  }
}

variable "password" {
  description = "Password of the initial admin user created in InfluxDB"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.password) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, password cannot be empty"
  }
}

variable "organization" {
  description = "Name of the initial organization for the initial admin user in InfluxDB"
  type        = string
  validation {
    condition     = length(var.organization) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, organization cannot be empty"
  }
}

variable "username" {
  description = "Username of the initial admin user created in InfluxDB"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z]", var.username)) && can(regex("[^-]$", var.username)) && !can(regex("--", var.username))
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, username must start with a letter and cannot end with a hyphen or contain two consecutive hyphens"
  }
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with the cluster"
  type        = list(string)
  validation {
    condition     = length(var.vpc_security_group_ids) > 0
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, vpc_security_group_ids must contain at least one security group ID"
  }
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet IDs to associate with the cluster"
  type        = list(string)
  validation {
    condition     = length(var.vpc_subnet_ids) >= 2
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, vpc_subnet_ids must contain at least two subnet IDs in different availability zones"
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "db_parameter_group_identifier" {
  description = "ID of the DB parameter group assigned to your cluster"
  type        = string
  default     = null
}

variable "db_storage_type" {
  description = "Timestream for InfluxDB DB storage type to read and write InfluxDB data"
  type        = string
  default     = "InfluxIOIncludedT1"
  validation {
    condition     = contains(["InfluxIOIncludedT1", "InfluxIOIncludedT2", "InfluxIOIncludedT3"], var.db_storage_type)
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, db_storage_type must be one of: InfluxIOIncludedT1, InfluxIOIncludedT2, InfluxIOIncludedT3"
  }
}

variable "deployment_type" {
  description = "Specifies the type of cluster to create"
  type        = string
  default     = "MULTI_NODE_READ_REPLICAS"
  validation {
    condition     = var.deployment_type == "MULTI_NODE_READ_REPLICAS"
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, deployment_type must be MULTI_NODE_READ_REPLICAS"
  }
}

variable "failover_mode" {
  description = "Specifies the behavior of failure recovery when the primary node of the cluster fails"
  type        = string
  default     = "AUTOMATIC"
  validation {
    condition     = contains(["AUTOMATIC", "NO_FAILOVER"], var.failover_mode)
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, failover_mode must be one of: AUTOMATIC, NO_FAILOVER"
  }
}

variable "network_type" {
  description = "Specifies whether the network type is IPV4 or DUAL"
  type        = string
  default     = null
  validation {
    condition     = var.network_type == null || contains(["IPV4", "DUAL"], var.network_type)
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, network_type must be one of: IPV4, DUAL"
  }
}

variable "port" {
  description = "The port on which the cluster accepts connections"
  type        = number
  default     = 8086
  validation {
    condition     = var.port >= 1024 && var.port <= 65535 && !contains([2375, 2376, 7788, 7789, 7790, 7791, 7792, 7793, 7794, 7795, 7796, 7797, 7798, 7799, 8090, 51678, 51679, 51680], var.port)
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, port must be between 1024-65535 and cannot be 2375-2376, 7788-7799, 8090, or 51678-51680"
  }
}

variable "publicly_accessible" {
  description = "Configures the DB cluster with a public IP to facilitate access"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "log_delivery_configuration" {
  description = "Configuration for sending InfluxDB engine logs to a specified S3 bucket"
  type = object({
    s3_configuration = object({
      bucket_name = string
      enabled     = bool
    })
  })
  default = null
  validation {
    condition = var.log_delivery_configuration == null || (
      var.log_delivery_configuration.s3_configuration != null &&
      length(var.log_delivery_configuration.s3_configuration.bucket_name) > 0
    )
    error_message = "resource_aws_timestreaminfluxdb_db_cluster, log_delivery_configuration s3_configuration bucket_name cannot be empty when log_delivery_configuration is specified"
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}