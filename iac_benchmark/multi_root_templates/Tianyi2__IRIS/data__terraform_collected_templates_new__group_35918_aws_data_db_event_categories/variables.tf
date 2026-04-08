variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_type" {
  description = "Type of source that will be generating the events. Valid options are db-instance, db-security-group, db-parameter-group, db-snapshot, db-cluster or db-cluster-snapshot."
  type        = string
  default     = null

  validation {
    condition = var.source_type == null ? true : contains([
      "db-instance",
      "db-security-group",
      "db-parameter-group",
      "db-snapshot",
      "db-cluster",
      "db-cluster-snapshot"
    ], var.source_type)
    error_message = "data_aws_db_event_categories, source_type must be one of: db-instance, db-security-group, db-parameter-group, db-snapshot, db-cluster, or db-cluster-snapshot."
  }
}