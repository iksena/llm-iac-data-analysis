variable "default_only" {
  type        = bool
  description = "Whether to return only default engine versions that match all other criteria. AWS may define multiple default versions for a given engine, so using `default_only` alone does not guarantee that only one version will be returned. To ensure a single version is selected, consider combining this with `latest`. Note that default versions are defined by AWS and may not reflect the most recent engine version available."
  default     = null
}

variable "engine" {
  type        = string
  description = "DB engine. Must be `neptune`."
  default     = "neptune"

  validation {
    condition     = var.engine == null || var.engine == "neptune"
    error_message = "data_aws_neptune_engine_version, engine must be 'neptune'."
  }
}

variable "has_major_target" {
  type        = bool
  description = "Whether to filter for engine versions that have a major target."
  default     = null
}

variable "has_minor_target" {
  type        = bool
  description = "Whether to filter for engine versions that have a minor target."
  default     = null
}

variable "latest" {
  type        = bool
  description = "Whether to return only the latest engine version that matches all other criteria. This differs from `default_only`: AWS may define multiple defaults, and the latest version is not always marked as the default. As a result, `default_only` may still return multiple versions, while `latest` selects a single version. The two options can be used together. **Note:** This argument uses a best-effort approach. Because AWS does not consistently provide version dates or standardized identifiers, the result may not always reflect the true latest version."
  default     = null
}

variable "parameter_group_family" {
  type        = string
  description = "Name of a specific DB parameter group family. An example parameter group family is `neptune1.4`. For some versions, if this is provided, AWS returns no results."
  default     = null
}

variable "preferred_major_targets" {
  type        = list(string)
  description = "Ordered list of preferred major engine versions."
  default     = null
}

variable "preferred_upgrade_targets" {
  type        = list(string)
  description = "Ordered list of preferred upgrade engine versions."
  default     = null
}

variable "preferred_versions" {
  type        = list(string)
  description = "Ordered list of preferred engine versions. The first match in this list will be returned. If no preferred matches are found and the original search returned more than one result, an error is returned. If both the `engine_version` and `preferred_versions` arguments are not configured, the data source will return the default version for the engine."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "engine_version" {
  type        = string
  description = "Version of the DB engine. For example, `1.0.1.0`, `1.0.2.2`, and `1.0.3.0`. If both the `engine_version` and `preferred_versions` arguments are not configured, the data source will return the default version for the engine."
  default     = null
}