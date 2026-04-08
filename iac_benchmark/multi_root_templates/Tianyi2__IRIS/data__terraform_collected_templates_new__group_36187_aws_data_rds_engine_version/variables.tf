variable "engine" {
  description = "Database engine. Engine values include aurora, aurora-mysql, aurora-postgresql, docdb, mariadb, mysql, neptune, oracle-ee, oracle-se, oracle-se1, oracle-se2, postgres, sqlserver-ee, sqlserver-ex, sqlserver-se, and sqlserver-web."
  type        = string

  validation {
    condition = contains([
      "aurora", "aurora-mysql", "aurora-postgresql", "docdb", "mariadb", "mysql",
      "neptune", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "postgres",
      "sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"
    ], var.engine)
    error_message = "data_aws_rds_engine_version, engine must be one of: aurora, aurora-mysql, aurora-postgresql, docdb, mariadb, mysql, neptune, oracle-ee, oracle-se, oracle-se1, oracle-se2, postgres, sqlserver-ee, sqlserver-ex, sqlserver-se, sqlserver-web."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "default_only" {
  description = "Whether the engine version must be an AWS-defined default version. Some engines have multiple default versions, such as for each major version. Using default_only may help avoid multiple RDS engine versions errors."
  type        = bool
  default     = null
}

variable "filter" {
  description = "One or more name/value pairs to use in filtering versions. There are several valid keys; for a full reference, check out describe-db-engine-versions in the AWS CLI reference."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for f in var.filter : f.name != null && length(f.name) > 0])
    error_message = "data_aws_rds_engine_version, filter name cannot be null or empty."
  }

  validation {
    condition     = alltrue([for f in var.filter : length(f.values) > 0])
    error_message = "data_aws_rds_engine_version, filter values list cannot be empty."
  }
}

variable "has_major_target" {
  description = "Whether the engine version must have one or more major upgrade targets. Not including has_major_target or setting it to false doesn't imply that there's no corresponding major upgrade target for the engine version."
  type        = bool
  default     = null
}

variable "has_minor_target" {
  description = "Whether the engine version must have one or more minor upgrade targets. Not including has_minor_target or setting it to false doesn't imply that there's no corresponding minor upgrade target for the engine version."
  type        = bool
  default     = null
}

variable "include_all" {
  description = "Whether the engine version status can either be deprecated or available. When not set or set to false, the engine version status will always be available."
  type        = bool
  default     = null
}

variable "latest" {
  description = "Whether the engine version is the most recent version matching the other criteria. This is different from default_only in important ways: default relies on AWS-defined defaults, the latest version isn't always the default, and AWS might have multiple default versions for an engine."
  type        = bool
  default     = null
}

variable "parameter_group_family" {
  description = "Name of a specific database parameter group family. Examples of parameter group families are mysql8.0, mariadb10.4, and postgres12."
  type        = string
  default     = null

  validation {
    condition     = var.parameter_group_family == null || length(var.parameter_group_family) > 0
    error_message = "data_aws_rds_engine_version, parameter_group_family cannot be empty string."
  }
}

variable "preferred_major_targets" {
  description = "Ordered list of preferred major version upgrade targets. The engine version will be the first match in the list unless the latest parameter is set to true."
  type        = list(string)
  default     = null

  validation {
    condition     = var.preferred_major_targets == null || length(var.preferred_major_targets) > 0
    error_message = "data_aws_rds_engine_version, preferred_major_targets list cannot be empty if specified."
  }
}

variable "preferred_upgrade_targets" {
  description = "Ordered list of preferred version upgrade targets. The engine version will be the first match in this list unless the latest parameter is set to true."
  type        = list(string)
  default     = null

  validation {
    condition     = var.preferred_upgrade_targets == null || length(var.preferred_upgrade_targets) > 0
    error_message = "data_aws_rds_engine_version, preferred_upgrade_targets list cannot be empty if specified."
  }
}

variable "preferred_versions" {
  description = "Ordered list of preferred versions. The engine version will be the first match in this list unless the latest parameter is set to true."
  type        = list(string)
  default     = null

  validation {
    condition     = var.preferred_versions == null || length(var.preferred_versions) > 0
    error_message = "data_aws_rds_engine_version, preferred_versions list cannot be empty if specified."
  }
}

variable "engine_version" {
  description = "Engine version. For example, 5.7.22, 10.1.34, or 12.3. Version can be a partial version identifier which can result in multiple RDS engine versions errors unless the latest parameter is set to true."
  type        = string
  default     = null

  validation {
    condition     = var.engine_version == null || length(var.engine_version) > 0
    error_message = "data_aws_rds_engine_version, engine_version cannot be empty string."
  }
}