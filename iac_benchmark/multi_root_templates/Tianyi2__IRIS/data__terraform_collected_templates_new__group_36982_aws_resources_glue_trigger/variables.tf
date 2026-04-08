variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "actions" {
  description = "List of actions initiated by this trigger when it fires"
  type = list(object({
    arguments              = optional(map(string))
    crawler_name           = optional(string)
    job_name               = optional(string)
    timeout                = optional(number)
    security_configuration = optional(string)
    notification_property = optional(object({
      notify_delay_after = optional(number)
    }))
  }))

  validation {
    condition     = length(var.actions) > 0
    error_message = "resource_aws_glue_trigger, actions - At least one action must be specified."
  }

  validation {
    condition = alltrue([
      for action in var.actions :
      (action.crawler_name != null && action.job_name == null) ||
      (action.job_name != null && action.crawler_name == null)
    ])
    error_message = "resource_aws_glue_trigger, actions - crawler_name conflicts with job_name. Only one can be specified."
  }
}

variable "description" {
  description = "A description of the new trigger"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Start the trigger"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the trigger"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_glue_trigger, name - Must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "predicate" {
  description = "A predicate to specify when the new trigger should fire"
  type = object({
    logical = optional(string, "AND")
    conditions = list(object({
      job_name         = optional(string)
      state            = optional(string)
      crawler_name     = optional(string)
      crawl_state      = optional(string)
      logical_operator = optional(string, "EQUALS")
    }))
  })
  default = null

  validation {
    condition = var.predicate == null || (
      var.predicate != null && var.predicate.logical != null ?
      contains(["AND", "ANY"], var.predicate.logical) : true
    )
    error_message = "resource_aws_glue_trigger, predicate.logical - Must be either 'AND' or 'ANY'."
  }

  validation {
    condition = var.predicate == null || (
      var.predicate != null && length(var.predicate.conditions) > 0
    )
    error_message = "resource_aws_glue_trigger, predicate.conditions - At least one condition must be specified when predicate is provided."
  }

  validation {
    condition = var.predicate == null || alltrue([
      for condition in var.predicate.conditions :
      (condition.job_name != null && condition.crawler_name == null) ||
      (condition.crawler_name != null && condition.job_name == null)
    ])
    error_message = "resource_aws_glue_trigger, predicate.conditions - job_name conflicts with crawler_name. Only one can be specified per condition."
  }

  validation {
    condition = var.predicate == null || alltrue([
      for condition in var.predicate.conditions :
      (condition.job_name != null && condition.state != null && condition.crawl_state == null) ||
      (condition.crawler_name != null && condition.crawl_state != null && condition.state == null) ||
      (condition.job_name == null && condition.crawler_name == null)
    ])
    error_message = "resource_aws_glue_trigger, predicate.conditions - state conflicts with crawl_state. When job_name is specified, state must be specified. When crawler_name is specified, crawl_state must be specified."
  }

  validation {
    condition = var.predicate == null || alltrue([
      for condition in var.predicate.conditions :
      condition.state == null || contains(["SUCCEEDED", "STOPPED", "TIMEOUT", "FAILED"], condition.state)
    ])
    error_message = "resource_aws_glue_trigger, predicate.conditions.state - Must be one of: SUCCEEDED, STOPPED, TIMEOUT, FAILED."
  }

  validation {
    condition = var.predicate == null || alltrue([
      for condition in var.predicate.conditions :
      condition.crawl_state == null || contains(["RUNNING", "SUCCEEDED", "CANCELLED", "FAILED"], condition.crawl_state)
    ])
    error_message = "resource_aws_glue_trigger, predicate.conditions.crawl_state - Must be one of: RUNNING, SUCCEEDED, CANCELLED, FAILED."
  }
}

variable "schedule" {
  description = "A cron expression used to specify the schedule"
  type        = string
  default     = null

  validation {
    condition     = var.schedule == null || can(regex("^cron\\(.*\\)$|^rate\\(.*\\)$", var.schedule))
    error_message = "resource_aws_glue_trigger, schedule - Must be a valid cron or rate expression."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "start_on_creation" {
  description = "Set to true to start SCHEDULED and CONDITIONAL triggers when created"
  type        = bool
  default     = null
}

variable "type" {
  description = "The type of trigger"
  type        = string

  validation {
    condition     = contains(["CONDITIONAL", "EVENT", "ON_DEMAND", "SCHEDULED"], var.type)
    error_message = "resource_aws_glue_trigger, type - Must be one of: CONDITIONAL, EVENT, ON_DEMAND, SCHEDULED."
  }
}

variable "workflow_name" {
  description = "A workflow to which the trigger should be associated to"
  type        = string
  default     = null
}

variable "event_batching_condition" {
  description = "Batch condition that must be met before EventBridge event trigger fires"
  type = object({
    batch_size   = number
    batch_window = optional(number, 900)
  })
  default = null

  validation {
    condition = var.event_batching_condition == null || (
      var.event_batching_condition != null && var.event_batching_condition.batch_size > 0
    )
    error_message = "resource_aws_glue_trigger, event_batching_condition.batch_size - Must be greater than 0."
  }

  validation {
    condition = var.event_batching_condition == null || (
      var.event_batching_condition != null && var.event_batching_condition.batch_window >= 1 && var.event_batching_condition.batch_window <= 900
    )
    error_message = "resource_aws_glue_trigger, event_batching_condition.batch_window - Must be between 1 and 900 seconds."
  }
}