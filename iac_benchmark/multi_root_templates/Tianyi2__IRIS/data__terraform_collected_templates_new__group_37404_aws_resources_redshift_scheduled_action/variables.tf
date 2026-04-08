variable "name" {
  description = "The scheduled action name"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_redshift_scheduled_action, name must not be empty."
  }
}

variable "description" {
  description = "The description of the scheduled action"
  type        = string
  default     = null
}

variable "enable" {
  description = "Whether to enable the scheduled action"
  type        = bool
  default     = true
}

variable "start_time" {
  description = "The start time in UTC when the schedule is active, in UTC RFC3339 format"
  type        = string
  default     = null

  validation {
    condition     = var.start_time == null || can(formatdate("2006-01-02T15:04:05Z", var.start_time))
    error_message = "resource_aws_redshift_scheduled_action, start_time must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "end_time" {
  description = "The end time in UTC when the schedule is active, in UTC RFC3339 format"
  type        = string
  default     = null

  validation {
    condition     = var.end_time == null || can(formatdate("2006-01-02T15:04:05Z", var.end_time))
    error_message = "resource_aws_redshift_scheduled_action, end_time must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "schedule" {
  description = "The schedule of action in 'at expression' or 'cron expression' format"
  type        = string

  validation {
    condition = length(var.schedule) > 0 && (
      can(regex("^at\\(", var.schedule)) ||
      can(regex("^cron\\(", var.schedule))
    )
    error_message = "resource_aws_redshift_scheduled_action, schedule must be in 'at(YYYY-MM-DDTHH:MM:SS)' or 'cron(expression)' format."
  }
}

variable "iam_role" {
  description = "The IAM role ARN to assume to run the scheduled action"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.iam_role))
    error_message = "resource_aws_redshift_scheduled_action, iam_role must be a valid IAM role ARN."
  }
}

variable "pause_cluster" {
  description = "Configuration for pause cluster action"
  type = object({
    cluster_identifier = string
  })
  default = null

  validation {
    condition = var.pause_cluster == null || (
      var.pause_cluster != null && length(var.pause_cluster.cluster_identifier) > 0
    )
    error_message = "resource_aws_redshift_scheduled_action, pause_cluster.cluster_identifier must not be empty when pause_cluster is specified."
  }
}

variable "resize_cluster" {
  description = "Configuration for resize cluster action"
  type = object({
    cluster_identifier = string
    classic            = optional(bool, false)
    cluster_type       = optional(string)
    node_type          = optional(string)
    number_of_nodes    = optional(number)
  })
  default = null

  validation {
    condition = var.resize_cluster == null || (
      var.resize_cluster != null && length(var.resize_cluster.cluster_identifier) > 0
    )
    error_message = "resource_aws_redshift_scheduled_action, resize_cluster.cluster_identifier must not be empty when resize_cluster is specified."
  }

  validation {
    condition     = var.resize_cluster == null || var.resize_cluster.number_of_nodes == null || var.resize_cluster.number_of_nodes > 0
    error_message = "resource_aws_redshift_scheduled_action, resize_cluster.number_of_nodes must be greater than 0 when specified."
  }
}

variable "resume_cluster" {
  description = "Configuration for resume cluster action"
  type = object({
    cluster_identifier = string
  })
  default = null

  validation {
    condition = var.resume_cluster == null || (
      var.resume_cluster != null && length(var.resume_cluster.cluster_identifier) > 0
    )
    error_message = "resource_aws_redshift_scheduled_action, resume_cluster.cluster_identifier must not be empty when resume_cluster is specified."
  }
}