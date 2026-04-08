variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Key-value pairs used to filter the results."
  type = list(object({
    key    = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.key != null && f.key != ""
    ])
    error_message = "data_aws_ssm_patch_baselines, filter: key cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ssm_patch_baselines, filter: values must contain at least one value."
  }
}

variable "default_baselines" {
  description = "Only return baseline identities where default_baseline is true."
  type        = bool
  default     = null
}