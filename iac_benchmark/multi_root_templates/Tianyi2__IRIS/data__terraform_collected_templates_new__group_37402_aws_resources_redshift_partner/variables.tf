variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The Amazon Web Services account ID that owns the cluster."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_redshift_partner, account_id must be a 12-digit AWS account ID."
  }
}

variable "cluster_identifier" {
  description = "The cluster identifier of the cluster that receives data from the partner."
  type        = string

  validation {
    condition     = length(var.cluster_identifier) > 0 && length(var.cluster_identifier) <= 63
    error_message = "resource_aws_redshift_partner, cluster_identifier must be between 1 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.cluster_identifier))
    error_message = "resource_aws_redshift_partner, cluster_identifier must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "database_name" {
  description = "The name of the database that receives data from the partner."
  type        = string

  validation {
    condition     = length(var.database_name) > 0 && length(var.database_name) <= 64
    error_message = "resource_aws_redshift_partner, database_name must be between 1 and 64 characters."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]*$", var.database_name))
    error_message = "resource_aws_redshift_partner, database_name must start with a letter and contain only lowercase letters, numbers, and underscores."
  }
}

variable "partner_name" {
  description = "The name of the partner that is authorized to send data."
  type        = string

  validation {
    condition     = length(var.partner_name) > 0 && length(var.partner_name) <= 255
    error_message = "resource_aws_redshift_partner, partner_name must be between 1 and 255 characters."
  }
}