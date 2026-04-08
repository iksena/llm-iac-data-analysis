variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_redshift_cluster, region must be a valid AWS region format."
  }
}

variable "cluster_identifier" {
  description = "Cluster identifier"
  type        = string

  validation {
    condition     = length(var.cluster_identifier) > 0 && length(var.cluster_identifier) <= 63
    error_message = "data_redshift_cluster, cluster_identifier must be between 1 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.cluster_identifier))
    error_message = "data_redshift_cluster, cluster_identifier must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}