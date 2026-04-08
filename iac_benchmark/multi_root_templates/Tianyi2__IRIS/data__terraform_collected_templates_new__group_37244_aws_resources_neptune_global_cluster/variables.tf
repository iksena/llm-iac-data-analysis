variable "global_cluster_identifier" {
  description = "(Required) Global cluster identifier."
  type        = string

  validation {
    condition     = length(var.global_cluster_identifier) > 0
    error_message = "resource_aws_neptune_global_cluster, global_cluster_identifier must not be empty."
  }
}

variable "deletion_protection" {
  description = "(Optional) If the Global Cluster should have deletion protection enabled. The database can't be deleted when this value is set to `true`. The default is `false`."
  type        = bool
  default     = false
}

variable "engine" {
  description = "(Optional) Name of the database engine to be used for this DB cluster. Terraform will only perform drift detection if a configuration value is provided. Current Valid values: `neptune`. Conflicts with `source_db_cluster_identifier`."
  type        = string
  default     = null

  validation {
    condition     = var.engine == null || var.engine == "neptune"
    error_message = "resource_aws_neptune_global_cluster, engine must be 'neptune' or null."
  }
}

variable "engine_version" {
  description = "(Optional) Engine version of the global database. Upgrading the engine version will result in all cluster members being immediately updated and will."
  type        = string
  default     = null
}

variable "region" {
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_db_cluster_identifier" {
  description = "(Optional) ARN to use as the primary DB Cluster of the Global Cluster on creation. Terraform cannot perform drift detection of this value."
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "(Optional) Whether the DB cluster is encrypted. The default is `false` unless `source_db_cluster_identifier` is specified and encrypted. Terraform will only perform drift detection if a configuration value is provided."
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Timeouts for the Global Cluster operations"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "120m")
    delete = optional(string, "5m")
  })
  default = null
}