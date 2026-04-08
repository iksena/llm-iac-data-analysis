variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the profiling group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_codeguruprofiler_profiling_group, name must be a non-empty string."
  }
}