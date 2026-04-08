variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "availability_zone_group" {
  description = "Availability zone group"
  type        = string
  default     = null
}

variable "engine_latest_version" {
  description = "When set to true, the data source attempts to return the most recent version matching the other criteria you provide. You must use engine_latest_version with preferred_instance_classes and/or preferred_engine_versions."
  type        = bool
  default     = null
}

variable "engine_version" {
  description = "Version of the DB engine. If none is provided, the data source tries to use the AWS-defined default version that matches any other criteria."
  type        = string
  default     = null
}

variable "engine" {
  description = "DB engine. Engine values include aurora, aurora-mysql, aurora-postgresql, docdb, mariadb, mysql, neptune, oracle-ee, oracle-se, oracle-se1, oracle-se2, postgres, sqlserver-ee, sqlserver-ex, sqlserver-se, and sqlserver-web."
  type        = string

  validation {
    condition = var.engine == null || contains([
      "aurora", "aurora-mysql", "aurora-postgresql", "docdb", "mariadb", "mysql",
      "neptune", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "postgres",
      "sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"
    ], var.engine)
    error_message = "data_aws_rds_orderable_db_instance, engine must be one of: aurora, aurora-mysql, aurora-postgresql, docdb, mariadb, mysql, neptune, oracle-ee, oracle-se, oracle-se1, oracle-se2, postgres, sqlserver-ee, sqlserver-ex, sqlserver-se, or sqlserver-web."
  }
}

variable "instance_class" {
  description = "DB instance class. Examples of classes are db.m3.2xlarge, db.t2.small, and db.m3.medium."
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model. Examples of license models are general-public-license, bring-your-own-license, and amazon-license."
  type        = string
  default     = null

  validation {
    condition = var.license_model == null || contains([
      "general-public-license", "bring-your-own-license", "amazon-license"
    ], var.license_model)
    error_message = "data_aws_rds_orderable_db_instance, license_model must be one of: general-public-license, bring-your-own-license, or amazon-license."
  }
}

variable "preferred_engine_versions" {
  description = "Ordered list of preferred RDS DB instance engine versions. When engine_latest_version is not set, the data source will return the first match in this list that matches any other criteria."
  type        = list(string)
  default     = null
}

variable "preferred_instance_classes" {
  description = "Ordered list of preferred RDS DB instance classes. The data source will return the first match in this list that matches any other criteria."
  type        = list(string)
  default     = null
}

variable "read_replica_capable" {
  description = "Whether a DB instance can have a read replica"
  type        = bool
  default     = null
}

variable "storage_type" {
  description = "Storage types. Examples of storage types are standard, io1, gp2, and aurora."
  type        = string
  default     = null

  validation {
    condition = var.storage_type == null || contains([
      "standard", "io1", "gp2", "aurora"
    ], var.storage_type)
    error_message = "data_aws_rds_orderable_db_instance, storage_type must be one of: standard, io1, gp2, or aurora."
  }
}

variable "supported_engine_modes" {
  description = "Use to limit results to engine modes such as provisioned"
  type        = list(string)
  default     = null
}

variable "supported_network_types" {
  description = "Use to limit results to network types IPV4 or DUAL"
  type        = list(string)
  default     = null

  validation {
    condition = var.supported_network_types == null || alltrue([
      for network_type in var.supported_network_types : contains(["IPV4", "DUAL"], network_type)
    ])
    error_message = "data_aws_rds_orderable_db_instance, supported_network_types must contain only: IPV4 or DUAL."
  }
}

variable "supports_clusters" {
  description = "Whether to limit results to instances that support clusters"
  type        = bool
  default     = null
}

variable "supports_multi_az" {
  description = "Whether to limit results to instances that are multi-AZ capable"
  type        = bool
  default     = null
}

variable "supports_enhanced_monitoring" {
  description = "Enable this to ensure a DB instance supports Enhanced Monitoring at intervals from 1 to 60 seconds"
  type        = bool
  default     = null
}

variable "supports_global_databases" {
  description = "Enable this to ensure a DB instance supports Aurora global databases with a specific combination of other DB engine attributes"
  type        = bool
  default     = null
}

variable "supports_iam_database_authentication" {
  description = "Enable this to ensure a DB instance supports IAM database authentication"
  type        = bool
  default     = null
}

variable "supports_iops" {
  description = "Enable this to ensure a DB instance supports provisioned IOPS"
  type        = bool
  default     = null
}

variable "supports_kerberos_authentication" {
  description = "Enable this to ensure a DB instance supports Kerberos Authentication"
  type        = bool
  default     = null
}

variable "supports_performance_insights" {
  description = "Enable this to ensure a DB instance supports Performance Insights"
  type        = bool
  default     = null
}

variable "supports_storage_autoscaling" {
  description = "Enable this to ensure Amazon RDS can automatically scale storage for DB instances that use the specified DB instance class"
  type        = bool
  default     = null
}

variable "supports_storage_encryption" {
  description = "Enable this to ensure a DB instance supports encrypted storage"
  type        = bool
  default     = null
}

variable "vpc" {
  description = "Boolean that indicates whether to show only VPC or non-VPC offerings"
  type        = bool
  default     = null
}