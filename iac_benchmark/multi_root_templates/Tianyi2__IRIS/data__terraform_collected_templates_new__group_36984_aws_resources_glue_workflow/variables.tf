variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_glue_workflow, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "name" {
  description = "The name you assign to this workflow."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "resource_aws_glue_workflow, name must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_glue_workflow, name must contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "default_run_properties" {
  description = "A map of default run properties for this workflow. These properties are passed to all jobs associated to the workflow."
  type        = map(string)
  default     = null

  validation {
    condition     = var.default_run_properties == null || length(var.default_run_properties) <= 50
    error_message = "resource_aws_glue_workflow, default_run_properties cannot exceed 50 key-value pairs."
  }
}

variable "description" {
  description = "Description of the workflow."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 2048
    error_message = "resource_aws_glue_workflow, description cannot exceed 2048 characters."
  }
}

variable "max_concurrent_runs" {
  description = "Prevents exceeding the maximum number of concurrent runs of any of the component jobs. If you leave this parameter blank, there is no limit to the number of concurrent workflow runs."
  type        = number
  default     = null

  validation {
    condition     = var.max_concurrent_runs == null || (var.max_concurrent_runs >= 1 && var.max_concurrent_runs <= 1000)
    error_message = "resource_aws_glue_workflow, max_concurrent_runs must be between 1 and 1000."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_glue_workflow, tags cannot exceed 50 key-value pairs."
  }

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) <= 128
    ])
    error_message = "resource_aws_glue_workflow, tags keys cannot exceed 128 characters."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_glue_workflow, tags values cannot exceed 256 characters."
  }
}