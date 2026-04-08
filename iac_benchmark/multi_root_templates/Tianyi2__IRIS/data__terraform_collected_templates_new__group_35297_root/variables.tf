variable "name_prefix" {
  description = "Common name prefix used to name resources"
  type        = string
}

variable "cluster_instance_name_prefix" {
  description = "Common name prefix used to name resources"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "engine" {
  description = "Common name prefix used to name resources"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the cluster will be deployed"
}

variable "backup_retention_period" {
  description = "Common name prefix used to name resources"
  type        = number
  default     = 1
}

variable "preferred_backup_window" {
  description = "Common name prefix used to name resources"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Common name prefix used to name resources"
  type        = string
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
  default     = null
}

variable "port" {
  type        = string
  description = "The port on which the DB accepts connections"
  default     = "27017"
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted. The default is false"
  default     = null
}

variable "engine_version" {
  type        = string
  description = "The database engine version. Updating this argument results in an outage."
}

variable "instance_count" {
  type        = number
  description = "The number of instances to be created and joined to the cluster"
  default     = 1
}

variable "instance_class" {
  type        = string
  description = "The instance class to use"
  default     = "db.t4g.medium"
}

variable "master_username" {
  type        = string
  description = "The password for the master db user. This should be created using a random string"
}

variable "master_password" {
  type        = string
  description = "The password for the master db password. This should be created using a random string"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "Enable log exports for audit or profiler logs"
}

variable "parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from one family to an other"
  type        = list(object({ apply_method = optional(string), value = string, name = string }))
  default     = []
}

variable "create_security_group" {
  type        = bool
  description = "Whether to create a security group for the cluster"
  default     = true
}

variable "revoke_rules_on_delete" {
  description = <<EOT
  Instruct Terraform to revoke all of the Security Groups attached
  ingress and egress rules before deleting the rule itself.
  Defaults to true
  EOT
  type        = bool
  default     = true
}

variable "security_group_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}

variable "cidr_blocks" {
  description = "ipv4 cidr ranges to associate with the security group"
  type        = list(string)
  default     = []
}

variable "prefix_list_ids" {
  description = "list of prefix lists to associate with the security group"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster"
  type        = list(string)
  default     = []
}

variable "enable_performance_insights" {
  description = "Enable performance insights for the cluster instances"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection for the cluster"
  type        = bool
  default     = null
}

variable "performance_insights_kms_key" {
  description = "KMS key ID to use for performance insights"
  type        = string
  default     = null
}

variable "promotion_tier" {
  description = "Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoter to writer"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "ca_cert_identifier" {
  description = "Identifier of the certificate authority (CA) certificate for the DB instance."
  type        = string
  default     = "rds-ca-rsa2048-g1"
}
