variable "database" {
  description = "The name of the database"
  type        = string

  validation {
    condition     = length(var.database) > 0
    error_message = "resource_aws_redshiftdata_statement, database must be a non-empty string."
  }
}

variable "sql" {
  description = "The SQL statement text to run"
  type        = string

  validation {
    condition     = length(var.sql) > 0
    error_message = "resource_aws_redshiftdata_statement, sql must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_redshiftdata_statement, region must be a valid AWS region format or null."
  }
}

variable "cluster_identifier" {
  description = "The cluster identifier. This parameter is required when connecting to a cluster and authenticating using either Secrets Manager or temporary credentials"
  type        = string
  default     = null

  validation {
    condition     = var.cluster_identifier == null || length(var.cluster_identifier) > 0
    error_message = "resource_aws_redshiftdata_statement, cluster_identifier must be a non-empty string or null."
  }
}

variable "db_user" {
  description = "The database user name"
  type        = string
  default     = null

  validation {
    condition     = var.db_user == null || length(var.db_user) > 0
    error_message = "resource_aws_redshiftdata_statement, db_user must be a non-empty string or null."
  }
}

variable "secret_arn" {
  description = "The name or ARN of the secret that enables access to the database"
  type        = string
  default     = null

  validation {
    condition     = var.secret_arn == null || length(var.secret_arn) > 0
    error_message = "resource_aws_redshiftdata_statement, secret_arn must be a non-empty string or null."
  }
}

variable "statement_name" {
  description = "The name of the SQL statement. You can name the SQL statement when you create it to identify the query"
  type        = string
  default     = null

  validation {
    condition     = var.statement_name == null || length(var.statement_name) > 0
    error_message = "resource_aws_redshiftdata_statement, statement_name must be a non-empty string or null."
  }
}

variable "with_event" {
  description = "A value that indicates whether to send an event to the Amazon EventBridge event bus after the SQL statement runs"
  type        = bool
  default     = null

  validation {
    condition     = var.with_event == null || can(tobool(var.with_event))
    error_message = "resource_aws_redshiftdata_statement, with_event must be a boolean value or null."
  }
}

variable "workgroup_name" {
  description = "The serverless workgroup name. This parameter is required when connecting to a serverless workgroup and authenticating using either Secrets Manager or temporary credentials"
  type        = string
  default     = null

  validation {
    condition     = var.workgroup_name == null || length(var.workgroup_name) > 0
    error_message = "resource_aws_redshiftdata_statement, workgroup_name must be a non-empty string or null."
  }
}