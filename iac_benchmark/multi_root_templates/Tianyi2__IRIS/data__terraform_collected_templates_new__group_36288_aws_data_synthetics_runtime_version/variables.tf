variable "prefix" {
  description = "Name prefix of the runtime version (for example, syn-nodejs-puppeteer)"
  type        = string

  validation {
    condition     = length(var.prefix) > 0
    error_message = "data_aws_synthetics_runtime_version, prefix must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "latest" {
  description = "Whether the latest version of the runtime should be fetched. Conflicts with version. Valid values: true"
  type        = bool
  default     = null

  validation {
    condition     = var.latest == null || var.latest == true
    error_message = "data_aws_synthetics_runtime_version, latest must be true when specified."
  }
}

variable "runtime_version" {
  description = "Version of the runtime to be fetched (for example, 9.0). Conflicts with latest"
  type        = string
  default     = null

  validation {
    condition     = var.runtime_version == null || length(var.runtime_version) > 0
    error_message = "data_aws_synthetics_runtime_version, runtime_version must not be empty when specified."
  }

  validation {
    condition     = !(var.latest != null && var.runtime_version != null)
    error_message = "data_aws_synthetics_runtime_version, runtime_version conflicts with latest - only one can be specified."
  }
}