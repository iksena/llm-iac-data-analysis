variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "engine" {
  description = "DB engine. Default: docdb"
  type        = string
  default     = "docdb"

  validation {
    condition     = var.engine != null && var.engine != ""
    error_message = "data_aws_docdb_engine_version, engine cannot be null or empty."
  }
}

variable "parameter_group_family" {
  description = "Name of a specific DB parameter group family. An example parameter group family is docdb3.6."
  type        = string
  default     = null
}

variable "preferred_versions" {
  description = "Ordered list of preferred engine versions. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned."
  type        = list(string)
  default     = null

  validation {
    condition = var.preferred_versions == null || (
      var.preferred_versions != null &&
      length(var.preferred_versions) > 0 &&
      alltrue([for v in var.preferred_versions : v != null && v != ""])
    )
    error_message = "data_aws_docdb_engine_version, preferred_versions must be null or a non-empty list with valid version strings."
  }
}

variable "engine_version" {
  description = "Version of the DB engine. For example, 3.6.0. If version and preferred_versions are not set, the data source will provide information for the AWS-defined default version."
  type        = string
  default     = null

  validation {
    condition = var.engine_version == null || (
      var.engine_version != null &&
      var.engine_version != "" &&
      can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.engine_version))
    )
    error_message = "data_aws_docdb_engine_version, version must be null or a valid version string in format x.y.z."
  }
}