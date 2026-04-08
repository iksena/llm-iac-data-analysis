variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "This parameter does not apply to Amazon DocumentDB. Amazon DocumentDB does not perform minor version upgrades regardless of the value set."
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "The EC2 Availability Zone that the DB instance is created in."
  type        = string
  default     = null
}

variable "ca_cert_identifier" {
  description = "The identifier of the certificate authority (CA) certificate for the DB instance."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The identifier of the aws_docdb_cluster in which to launch this instance."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.cluster_identifier))
    error_message = "resource_aws_docdb_cluster_instance, cluster_identifier must start with a letter and can only contain letters, numbers, and hyphens."
  }
}

variable "copy_tags_to_snapshot" {
  description = "Copy all DB instance tags to snapshots."
  type        = bool
  default     = false
}

variable "enable_performance_insights" {
  description = "A value that indicates whether to enable Performance Insights for the DB Instance."
  type        = bool
  default     = false
}

variable "engine" {
  description = "The name of the database engine to be used for the DocumentDB instance."
  type        = string
  default     = "docdb"

  validation {
    condition     = contains(["docdb"], var.engine)
    error_message = "resource_aws_docdb_cluster_instance, engine must be 'docdb'."
  }
}

variable "identifier" {
  description = "The identifier for the DocumentDB instance, if omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = null

  validation {
    condition     = var.identifier == null || can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.identifier))
    error_message = "resource_aws_docdb_cluster_instance, identifier must start with a letter and can only contain letters, numbers, and hyphens."
  }
}

variable "identifier_prefix" {
  description = "Creates a unique identifier beginning with the specified prefix. Conflicts with identifier."
  type        = string
  default     = null

  validation {
    condition     = var.identifier_prefix == null || can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.identifier_prefix))
    error_message = "resource_aws_docdb_cluster_instance, identifier_prefix must start with a letter and can only contain letters, numbers, and hyphens."
  }
}

variable "instance_class" {
  description = "The instance class to use. For details on CPU and memory, see Scaling for DocumentDB Instances."
  type        = string

  validation {
    condition = contains([
      "db.r6g.large", "db.r6g.xlarge", "db.r6g.2xlarge", "db.r6g.4xlarge",
      "db.r6g.8xlarge", "db.r6g.12xlarge", "db.r6g.16xlarge",
      "db.r5.large", "db.r5.xlarge", "db.r5.2xlarge", "db.r5.4xlarge",
      "db.r5.12xlarge", "db.r5.24xlarge",
      "db.r4.large", "db.r4.xlarge", "db.r4.2xlarge", "db.r4.4xlarge",
      "db.r4.8xlarge", "db.r4.16xlarge",
      "db.t4g.medium", "db.t3.medium"
    ], var.instance_class)
    error_message = "resource_aws_docdb_cluster_instance, instance_class must be one of: db.r6g.large, db.r6g.xlarge, db.r6g.2xlarge, db.r6g.4xlarge, db.r6g.8xlarge, db.r6g.12xlarge, db.r6g.16xlarge, db.r5.large, db.r5.xlarge, db.r5.2xlarge, db.r5.4xlarge, db.r5.12xlarge, db.r5.24xlarge, db.r4.large, db.r4.xlarge, db.r4.2xlarge, db.r4.4xlarge, db.r4.8xlarge, db.r4.16xlarge, db.t4g.medium, db.t3.medium."
  }
}

variable "performance_insights_kms_key_id" {
  description = "The KMS key identifier is the key ARN, key ID, alias ARN, or alias name for the KMS key. If you do not specify a value for PerformanceInsightsKMSKeyId, then Amazon DocumentDB uses your default KMS key."
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'."
  type        = string
  default     = null

  validation {
    condition     = var.preferred_maintenance_window == null || can(regex("^(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]-(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]$", lower(var.preferred_maintenance_window)))
    error_message = "resource_aws_docdb_cluster_instance, preferred_maintenance_window must be in format 'ddd:hh24:mi-ddd:hh24:mi' where ddd is a day of the week (sun, mon, tue, wed, thu, fri, sat), hh24 is hour (00-23), and mi is minute (00-59)."
  }
}

variable "promotion_tier" {
  description = "Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoter to writer."
  type        = number
  default     = 0

  validation {
    condition     = var.promotion_tier >= 0 && var.promotion_tier <= 15
    error_message = "resource_aws_docdb_cluster_instance, promotion_tier must be between 0 and 15."
  }
}

variable "tags" {
  description = "A map of tags to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for creating the DocumentDB cluster instance."
  type        = string
  default     = "90m"
}

variable "timeouts_update" {
  description = "Timeout for updating the DocumentDB cluster instance."
  type        = string
  default     = "90m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the DocumentDB cluster instance."
  type        = string
  default     = "90m"
}