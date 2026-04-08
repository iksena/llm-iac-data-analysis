variable "region" {
  description = "AWS region for the provider configuration."
  type        = string
}

variable "observability_configuration_name" {
  description = "Name of the observability configuration."
  type        = string

  validation {
    condition     = length(var.observability_configuration_name) > 0
    error_message = "resource_aws_apprunner_observability_configuration, observability_configuration_name must not be empty."
  }
}

variable "trace_configuration" {
  description = "Configuration of the tracing feature within this observability configuration. If you don't specify it, App Runner doesn't enable tracing."
  type = object({
    vendor = string
  })
  default = null

  validation {
    condition = var.trace_configuration == null || (
      var.trace_configuration.vendor != null &&
      contains(["AWSXRAY"], var.trace_configuration.vendor)
    )
    error_message = "resource_aws_apprunner_observability_configuration, trace_configuration.vendor must be 'AWSXRAY' when trace_configuration is specified."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}