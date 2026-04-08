variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The Cluster Identifier. Must be a lower case string"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.cluster_identifier))
    error_message = "resource_aws_redshift_cluster, cluster_identifier must be a lower case string."
  }
}

variable "database_name" {
  description = "The name of the first database to be created when the cluster is created"
  type        = string
  default     = null
}

variable "default_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) for the IAM role that was set as default for the cluster"
  type        = string
  default     = null
}

variable "node_type" {
  description = "The node type to be provisioned for the cluster"
  type        = string
}

variable "cluster_type" {
  description = "The cluster type to use. Either single-node or multi-node"
  type        = string
  default     = null
  validation {
    condition     = var.cluster_type == null || contains(["single-node", "multi-node"], var.cluster_type)
    error_message = "resource_aws_redshift_cluster, cluster_type must be either 'single-node' or 'multi-node'."
  }
}

variable "manage_master_password" {
  description = "Whether to use AWS SecretsManager to manage the cluster admin credentials"
  type        = bool
  default     = null
}

variable "master_password" {
  description = "Password for the master DB user. Must contain at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one number"
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition = var.master_password == null || (
      length(var.master_password) >= 8 &&
      can(regex("[A-Z]", var.master_password)) &&
      can(regex("[a-z]", var.master_password)) &&
      can(regex("[0-9]", var.master_password))
    )
    error_message = "resource_aws_redshift_cluster, master_password must contain at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one number."
  }
}

variable "master_password_wo" {
  description = "Write-only password for the master DB user. Must contain at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one number"
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition = var.master_password_wo == null || (
      length(var.master_password_wo) >= 8 &&
      can(regex("[A-Z]", var.master_password_wo)) &&
      can(regex("[a-z]", var.master_password_wo)) &&
      can(regex("[0-9]", var.master_password_wo))
    )
    error_message = "resource_aws_redshift_cluster, master_password_wo must contain at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one number."
  }
}

variable "master_password_wo_version" {
  description = "Used together with master_password_wo to trigger an update"
  type        = number
  default     = null
}

variable "master_password_secret_kms_key_id" {
  description = "ID of the KMS key used to encrypt the cluster admin credentials secret"
  type        = string
  default     = null
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the Redshift cluster is multi-AZ"
  type        = bool
  default     = null
}

variable "vpc_security_group_ids" {
  description = "A list of Virtual Private Cloud (VPC) security groups to be associated with the cluster"
  type        = list(string)
  default     = null
}

variable "cluster_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The EC2 Availability Zone (AZ) in which you want Amazon Redshift to provision the cluster"
  type        = string
  default     = null
}

variable "availability_zone_relocation_enabled" {
  description = "If true, the cluster can be relocated to another availabity zone. Default is false"
  type        = bool
  default     = false
}

variable "preferred_maintenance_window" {
  description = "The weekly time range (in UTC) during which automated cluster maintenance can occur. Format: ddd:hh24:mi-ddd:hh24:mi"
  type        = string
  default     = null
  validation {
    condition     = var.preferred_maintenance_window == null || can(regex("^[a-z]{3}:[0-9]{2}:[0-9]{2}-[a-z]{3}:[0-9]{2}:[0-9]{2}$", var.preferred_maintenance_window))
    error_message = "resource_aws_redshift_cluster, preferred_maintenance_window must be in format ddd:hh24:mi-ddd:hh24:mi."
  }
}

variable "cluster_parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster"
  type        = string
  default     = null
}

variable "automated_snapshot_retention_period" {
  description = "The number of days that automated snapshots are retained. Default is 1"
  type        = number
  default     = 1
  validation {
    condition     = var.automated_snapshot_retention_period >= 0
    error_message = "resource_aws_redshift_cluster, automated_snapshot_retention_period must be greater than or equal to 0."
  }
}

variable "port" {
  description = "The port number on which the cluster accepts incoming connections. Valid values are between 1115 and 65535. Default port is 5439"
  type        = number
  default     = 5439
  validation {
    condition     = var.port >= 1115 && var.port <= 65535
    error_message = "resource_aws_redshift_cluster, port must be between 1115 and 65535."
  }
}

variable "cluster_version" {
  description = "The version of the Amazon Redshift engine software that you want to deploy on the cluster"
  type        = string
  default     = null
}

variable "allow_version_upgrade" {
  description = "If true, major version upgrades can be applied during the maintenance window. Default is true"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is false"
  type        = bool
  default     = false
}

variable "aqua_configuration_status" {
  description = "The value represents how the cluster is configured to use AQUA. Deprecated - no longer supported by AWS API"
  type        = string
  default     = null
}

variable "number_of_nodes" {
  description = "The number of compute nodes in the cluster. Required when ClusterType is multi-node. Default is 1"
  type        = number
  default     = 1
  validation {
    condition     = var.number_of_nodes >= 1
    error_message = "resource_aws_redshift_cluster, number_of_nodes must be greater than or equal to 1."
  }
}

variable "publicly_accessible" {
  description = "If true, the cluster can be accessed from a public network. Default is false"
  type        = bool
  default     = false
}

variable "encrypted" {
  description = "If true, the data in the cluster is encrypted at rest. Default is true"
  type        = bool
  default     = true
}

variable "enhanced_vpc_routing" {
  description = "If true, enhanced VPC routing is enabled"
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true"
  type        = string
  default     = null
}

variable "elastic_ip" {
  description = "The Elastic IP (EIP) address for the cluster"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final snapshot of the cluster is created before Amazon Redshift deletes the cluster. Default is false"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The identifier of the final snapshot that is to be created immediately before deleting the cluster"
  type        = string
  default     = null
}

variable "snapshot_arn" {
  description = "The ARN of the snapshot from which to create the new cluster. Conflicts with snapshot_identifier"
  type        = string
  default     = null
}

variable "snapshot_identifier" {
  description = "The name of the snapshot from which to create the new cluster. Conflicts with snapshot_arn"
  type        = string
  default     = null
}

variable "snapshot_cluster_identifier" {
  description = "The name of the cluster the source snapshot was created from"
  type        = string
  default     = null
}

variable "owner_account" {
  description = "The AWS customer account used to create or copy the snapshot"
  type        = string
  default     = null
}

variable "iam_roles" {
  description = "A list of IAM Role ARNs to associate with the cluster. Maximum of 10 can be associated"
  type        = list(string)
  default     = null
  validation {
    condition     = var.iam_roles == null || length(var.iam_roles) <= 10
    error_message = "resource_aws_redshift_cluster, iam_roles maximum of 10 IAM roles can be associated with the cluster."
  }
}

variable "maintenance_track_name" {
  description = "The name of the maintenance track for the restored cluster. Default value is current"
  type        = string
  default     = "current"
}

variable "manual_snapshot_retention_period" {
  description = "The default number of days to retain a manual snapshot. Valid values are between -1 and 3653. Default value is -1"
  type        = number
  default     = -1
  validation {
    condition     = var.manual_snapshot_retention_period >= -1 && var.manual_snapshot_retention_period <= 3653
    error_message = "resource_aws_redshift_cluster, manual_snapshot_retention_period must be between -1 and 3653."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = null
}