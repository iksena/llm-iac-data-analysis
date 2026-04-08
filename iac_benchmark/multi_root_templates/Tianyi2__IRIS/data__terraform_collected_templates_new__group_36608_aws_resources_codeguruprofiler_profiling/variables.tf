variable "name" {
  description = "Name of the profiling group"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codeguruprofiler_profiling_group, name must not be empty."
  }
}

variable "agent_orchestration_config" {
  description = "Specifies whether profiling is enabled or disabled for the created profiling group"
  type = object({
    profiling_enabled = bool
  })

  validation {
    condition     = can(var.agent_orchestration_config.profiling_enabled)
    error_message = "resource_aws_codeguruprofiler_profiling_group, agent_orchestration_config.profiling_enabled must be specified."
  }
}

variable "compute_platform" {
  description = "Compute platform of the profiling group"
  type        = string
  default     = null

  validation {
    condition     = var.compute_platform == null || can(regex("^(Default|AWSLambda)$", var.compute_platform))
    error_message = "resource_aws_codeguruprofiler_profiling_group, compute_platform must be either 'Default' or 'AWSLambda'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_codeguruprofiler_profiling_group, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_codeguruprofiler_profiling_group, tags must be a valid map of strings."
  }
}