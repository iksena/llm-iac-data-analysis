variable "name" {
  description = "The name you assign to this job. It must be unique in your account."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_glue_job, name must not be empty."
  }
}

variable "role_arn" {
  description = "The ARN of the IAM role associated with this job."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.role_arn))
    error_message = "resource_aws_glue_job, role_arn must be a valid IAM role ARN."
  }
}

variable "command" {
  description = "The command of the job."
  type = object({
    name            = optional(string, "glueetl")
    script_location = string
    python_version  = optional(string)
    runtime         = optional(string)
  })

  validation {
    condition     = length(var.command.script_location) > 0
    error_message = "resource_aws_glue_job, command.script_location must not be empty."
  }

  validation {
    condition = var.command.name == null || contains([
      "glueetl", "pythonshell", "glueray", "gluestreaming"
    ], var.command.name)
    error_message = "resource_aws_glue_job, command.name must be one of: glueetl, pythonshell, glueray, gluestreaming."
  }

  validation {
    condition = var.command.python_version == null || contains([
      "2", "3", "3.9"
    ], var.command.python_version)
    error_message = "resource_aws_glue_job, command.python_version must be one of: 2, 3, 3.9."
  }
}

variable "connections" {
  description = "The list of connections used for this job."
  type        = list(string)
  default     = []
}

variable "default_arguments" {
  description = "The map of default arguments for this job."
  type        = map(string)
  default     = {}
}

variable "description" {
  description = "Description of the job."
  type        = string
  default     = null
}

variable "execution_class" {
  description = "Indicates whether the job is run with a standard or flexible execution class."
  type        = string
  default     = null

  validation {
    condition = var.execution_class == null || contains([
      "FLEX", "STANDARD"
    ], var.execution_class)
    error_message = "resource_aws_glue_job, execution_class must be one of: FLEX, STANDARD."
  }
}

variable "execution_property" {
  description = "Execution property of the job."
  type = object({
    max_concurrent_runs = optional(number, 1)
  })
  default = null

  validation {
    condition = var.execution_property == null || (
      var.execution_property.max_concurrent_runs == null ||
      var.execution_property.max_concurrent_runs >= 1
    )
    error_message = "resource_aws_glue_job, execution_property.max_concurrent_runs must be >= 1."
  }
}

variable "glue_version" {
  description = "The version of glue to use, for example '1.0'. Ray jobs should set this to 4.0 or greater."
  type        = string
  default     = null
}

variable "job_mode" {
  description = "Describes how a job was created."
  type        = string
  default     = null

  validation {
    condition = var.job_mode == null || contains([
      "SCRIPT", "NOTEBOOK", "VISUAL"
    ], var.job_mode)
    error_message = "resource_aws_glue_job, job_mode must be one of: SCRIPT, NOTEBOOK, VISUAL."
  }
}

variable "job_run_queuing_enabled" {
  description = "Specifies whether job run queuing is enabled for the job runs for this job."
  type        = bool
  default     = null
}

variable "maintenance_window" {
  description = "Specifies the day of the week and hour for the maintenance window for streaming jobs."
  type        = string
  default     = null
}

variable "max_capacity" {
  description = "The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs."
  type        = number
  default     = null

  validation {
    condition = var.max_capacity == null || (
      var.max_capacity == 0.0625 || var.max_capacity == 1.0 || var.max_capacity >= 2
    )
    error_message = "resource_aws_glue_job, max_capacity must be 0.0625, 1.0, or >= 2."
  }
}

variable "max_retries" {
  description = "The maximum number of times to retry this job if it fails."
  type        = number
  default     = null

  validation {
    condition     = var.max_retries == null || var.max_retries >= 0
    error_message = "resource_aws_glue_job, max_retries must be >= 0."
  }
}

variable "non_overridable_arguments" {
  description = "Non-overridable arguments for this job, specified as name-value pairs."
  type        = map(string)
  default     = {}
}

variable "notification_property" {
  description = "Notification property of the job."
  type = object({
    notify_delay_after = optional(number)
  })
  default = null

  validation {
    condition = var.notification_property == null || (
      var.notification_property.notify_delay_after == null ||
      var.notification_property.notify_delay_after >= 1
    )
    error_message = "resource_aws_glue_job, notification_property.notify_delay_after must be >= 1."
  }
}

variable "number_of_workers" {
  description = "The number of workers of a defined workerType that are allocated when a job runs."
  type        = number
  default     = null

  validation {
    condition     = var.number_of_workers == null || var.number_of_workers >= 1
    error_message = "resource_aws_glue_job, number_of_workers must be >= 1."
  }
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "security_configuration" {
  description = "The name of the Security Configuration to be associated with the job."
  type        = string
  default     = null
}

variable "source_control_details" {
  description = "The details for a source control configuration for a job."
  type = object({
    auth_strategy  = optional(string)
    auth_token     = optional(string)
    branch         = optional(string)
    folder         = optional(string)
    last_commit_id = optional(string)
    owner          = optional(string)
    provider       = optional(string)
    repository     = optional(string)
  })
  default = null

  validation {
    condition = var.source_control_details == null || (
      var.source_control_details.auth_strategy == null ||
      contains(["PERSONAL_ACCESS_TOKEN", "AWS_SECRETS_MANAGER"], var.source_control_details.auth_strategy)
    )
    error_message = "resource_aws_glue_job, source_control_details.auth_strategy must be one of: PERSONAL_ACCESS_TOKEN, AWS_SECRETS_MANAGER."
  }

  validation {
    condition = var.source_control_details == null || (
      var.source_control_details.provider == null ||
      contains(["GITHUB", "GITLAB", "BITBUCKET", "AWS_CODE_COMMIT"], var.source_control_details.provider)
    )
    error_message = "resource_aws_glue_job, source_control_details.provider must be one of: GITHUB, GITLAB, BITBUCKET, AWS_CODE_COMMIT."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "The job timeout in minutes."
  type        = number
  default     = null

  validation {
    condition     = var.timeout == null || var.timeout >= 1
    error_message = "resource_aws_glue_job, timeout must be >= 1."
  }
}

variable "worker_type" {
  description = "The type of predefined worker that is allocated when a job runs."
  type        = string
  default     = null

  validation {
    condition = var.worker_type == null || contains([
      "Standard", "G.1X", "G.2X", "G.025X", "G.4X", "G.8X", "G.12X", "G.16X",
      "R.1X", "R.2X", "R.4X", "R.8X", "Z.2X"
    ], var.worker_type)
    error_message = "resource_aws_glue_job, worker_type must be one of: Standard, G.1X, G.2X, G.025X, G.4X, G.8X, G.12X, G.16X, R.1X, R.2X, R.4X, R.8X, Z.2X."
  }
}