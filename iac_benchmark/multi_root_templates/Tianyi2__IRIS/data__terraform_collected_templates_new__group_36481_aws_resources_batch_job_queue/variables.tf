variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Specifies the name of the job queue."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_batch_job_queue, name cannot be empty."
  }
}

variable "priority" {
  description = "The priority of the job queue. Job queues with a higher priority are evaluated first when associated with the same compute environment."
  type        = number
  validation {
    condition     = var.priority >= 0
    error_message = "resource_aws_batch_job_queue, priority must be a non-negative integer."
  }
}

variable "state" {
  description = "The state of the job queue. Must be one of: ENABLED or DISABLED"
  type        = string
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "resource_aws_batch_job_queue, state must be one of: ENABLED, DISABLED."
  }
}

variable "scheduling_policy_arn" {
  description = "The ARN of the fair share scheduling policy. If this parameter is specified, the job queue uses a fair share scheduling policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "compute_environment_order" {
  description = "The set of compute environments mapped to a job queue and their order relative to each other. You can associate up to three compute environments with a job queue."
  type = list(object({
    compute_environment = string
    order               = number
  }))
  default = []
  validation {
    condition     = length(var.compute_environment_order) <= 3
    error_message = "resource_aws_batch_job_queue, compute_environment_order can have at most 3 compute environments."
  }
  validation {
    condition = alltrue([
      for ce in var.compute_environment_order : ce.order >= 0
    ])
    error_message = "resource_aws_batch_job_queue, compute_environment_order order must be a non-negative integer."
  }
  validation {
    condition = alltrue([
      for ce in var.compute_environment_order : length(ce.compute_environment) > 0
    ])
    error_message = "resource_aws_batch_job_queue, compute_environment_order compute_environment cannot be empty."
  }
}

variable "job_state_time_limit_action" {
  description = "The set of job state time limit actions mapped to a job queue. Specifies an action that AWS Batch will take after the job has remained at the head of the queue in the specified state for longer than the specified time."
  type = list(object({
    action           = string
    max_time_seconds = number
    reason           = string
    state            = string
  }))
  default = []
  validation {
    condition = alltrue([
      for action in var.job_state_time_limit_action : action.action == "CANCEL"
    ])
    error_message = "resource_aws_batch_job_queue, job_state_time_limit_action action must be CANCEL."
  }
  validation {
    condition = alltrue([
      for action in var.job_state_time_limit_action : action.max_time_seconds >= 600 && action.max_time_seconds <= 86400
    ])
    error_message = "resource_aws_batch_job_queue, job_state_time_limit_action max_time_seconds must be between 600 and 86400."
  }
  validation {
    condition = alltrue([
      for action in var.job_state_time_limit_action : length(action.reason) > 0
    ])
    error_message = "resource_aws_batch_job_queue, job_state_time_limit_action reason cannot be empty."
  }
  validation {
    condition = alltrue([
      for action in var.job_state_time_limit_action : action.state == "RUNNABLE"
    ])
    error_message = "resource_aws_batch_job_queue, job_state_time_limit_action state must be RUNNABLE."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}