variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_create" {
  description = "Create a database user with the name specified for the user named in db_user if one does not exist."
  type        = bool
  default     = null
}

variable "cluster_identifier" {
  description = "Unique identifier of the cluster that contains the database for which your are requesting credentials."
  type        = string

  validation {
    condition     = var.cluster_identifier != null && var.cluster_identifier != ""
    error_message = "data_aws_redshift_cluster_credentials, cluster_identifier must be provided and cannot be empty."
  }
}

variable "db_name" {
  description = "Name of a database that DbUser is authorized to log on to. If db_name is not specified, db_user can log on to any existing database."
  type        = string
  default     = null
}

variable "db_user" {
  description = "Name of a database user. If a user name matching db_user exists in the database, the temporary user credentials have the same permissions as the existing user."
  type        = string

  validation {
    condition     = var.db_user != null && var.db_user != ""
    error_message = "data_aws_redshift_cluster_credentials, db_user must be provided and cannot be empty."
  }
}

variable "db_groups" {
  description = "List of the names of existing database groups that the user named in db_user will join for the current session, in addition to any group memberships for an existing user."
  type        = list(string)
  default     = null
}

variable "duration_seconds" {
  description = "The number of seconds until the returned temporary password expires. Valid values are between 900 and 3600. Default value is 900."
  type        = number
  default     = 900

  validation {
    condition     = var.duration_seconds >= 900 && var.duration_seconds <= 3600
    error_message = "data_aws_redshift_cluster_credentials, duration_seconds must be between 900 and 3600."
  }
}