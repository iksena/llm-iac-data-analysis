variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the project"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_devicefarm_project, name must contain only alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "default_job_timeout_minutes" {
  description = "Sets the execution timeout value (in minutes) for a project. All test runs in this project use the specified execution timeout value unless overridden when scheduling a run."
  type        = number
  default     = null

  validation {
    condition     = var.default_job_timeout_minutes == null || (var.default_job_timeout_minutes > 0 && var.default_job_timeout_minutes <= 150)
    error_message = "resource_aws_devicefarm_project, default_job_timeout_minutes must be between 1 and 150 minutes."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}