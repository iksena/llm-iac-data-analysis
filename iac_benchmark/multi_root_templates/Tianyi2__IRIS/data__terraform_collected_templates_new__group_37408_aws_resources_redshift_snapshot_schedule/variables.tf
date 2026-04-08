variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The cluster identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.cluster_identifier)) && !can(regex("^-", var.cluster_identifier)) && !can(regex("-$", var.cluster_identifier))
    error_message = "resource_aws_redshift_snapshot_schedule_association, cluster_identifier must be 1-63 characters long, contain only lowercase letters, numbers, and hyphens, and cannot start or end with a hyphen."
  }
}

variable "schedule_identifier" {
  description = "The snapshot schedule identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,255}$", var.schedule_identifier)) && !can(regex("^-", var.schedule_identifier)) && !can(regex("-$", var.schedule_identifier))
    error_message = "resource_aws_redshift_snapshot_schedule_association, schedule_identifier must be 1-255 characters long, contain only lowercase letters, numbers, and hyphens, and cannot start or end with a hyphen."
  }
}