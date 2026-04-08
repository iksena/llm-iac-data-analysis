variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "A custom name for the job. The name can contain as many as 500 characters"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^.{1,500}$", var.name))
    error_message = "resource_aws_macie2_classification_job, name must be between 1 and 500 characters long."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "description" {
  description = "A custom description of the job. The description can contain as many as 200 characters"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || can(regex("^.{0,200}$", var.description))
    error_message = "resource_aws_macie2_classification_job, description must be no more than 200 characters long."
  }
}

variable "job_type" {
  description = "The schedule for running the job"
  type        = string

  validation {
    condition     = contains(["ONE_TIME", "SCHEDULED"], var.job_type)
    error_message = "resource_aws_macie2_classification_job, job_type must be either 'ONE_TIME' or 'SCHEDULED'."
  }
}

variable "job_status" {
  description = "The status for the job"
  type        = string
  default     = null

  validation {
    condition     = var.job_status == null || contains(["CANCELLED", "RUNNING", "USER_PAUSED"], var.job_status)
    error_message = "resource_aws_macie2_classification_job, job_status must be one of 'CANCELLED', 'RUNNING', or 'USER_PAUSED'."
  }
}

variable "initial_run" {
  description = "Specifies whether to analyze all existing, eligible objects immediately after the job is created"
  type        = bool
  default     = null
}

variable "sampling_percentage" {
  description = "The sampling depth, as a percentage, to apply when processing objects"
  type        = number
  default     = null

  validation {
    condition     = var.sampling_percentage == null || (var.sampling_percentage >= 0 && var.sampling_percentage <= 100)
    error_message = "resource_aws_macie2_classification_job, sampling_percentage must be between 0 and 100."
  }
}

variable "custom_data_identifier_ids" {
  description = "The custom data identifiers to use for data analysis and classification"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "schedule_frequency" {
  description = "The recurrence pattern for running the job"
  type = object({
    daily_schedule   = optional(bool)
    weekly_schedule  = optional(string)
    monthly_schedule = optional(number)
  })
  default = null

  validation {
    condition = var.schedule_frequency == null || (
      var.schedule_frequency.daily_schedule != null ||
      var.schedule_frequency.weekly_schedule != null ||
      var.schedule_frequency.monthly_schedule != null
    )
    error_message = "resource_aws_macie2_classification_job, schedule_frequency must specify at least one of daily_schedule, weekly_schedule, or monthly_schedule."
  }
}

variable "s3_job_definition" {
  description = "The S3 buckets that contain the objects to analyze, and the scope of that analysis"
  type = object({
    bucket_criteria = optional(object({
      excludes = optional(object({
        and = optional(list(object({
          simple_criterion = optional(object({
            comparator = string
            key        = string
            values     = list(string)
          }))
          tag_criterion = optional(object({
            comparator = string
            tag_values = list(object({
              key   = string
              value = string
            }))
          }))
        })))
      }))
      includes = optional(object({
        and = optional(list(object({
          simple_criterion = optional(object({
            comparator = string
            key        = string
            values     = list(string)
          }))
          tag_criterion = optional(object({
            comparator = string
            tag_values = list(object({
              key   = string
              value = string
            }))
          }))
        })))
      }))
    }))
    bucket_definitions = optional(list(object({
      account_id = string
      buckets    = list(string)
    })))
    scoping = optional(object({
      excludes = optional(object({
        and = optional(list(object({
          simple_scope_term = optional(object({
            comparator = optional(string)
            key        = optional(string)
            values     = optional(list(string))
          }))
          tag_scope_term = optional(object({
            comparator = optional(string)
            key        = string
            target     = string
            tag_values = optional(list(string))
          }))
        })))
      }))
      includes = optional(object({
        and = optional(list(object({
          simple_scope_term = optional(object({
            comparator = optional(string)
            key        = optional(string)
            values     = optional(list(string))
          }))
          tag_scope_term = optional(object({
            comparator = optional(string)
            key        = string
            target     = string
            tag_values = optional(list(string))
          }))
        })))
      }))
    }))
  })
  default = null

  validation {
    condition = var.s3_job_definition == null || (
      (var.s3_job_definition.bucket_criteria == null) != (var.s3_job_definition.bucket_definitions == null)
    )
    error_message = "resource_aws_macie2_classification_job, s3_job_definition must specify either bucket_criteria or bucket_definitions, but not both."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.bucket_definitions == null || alltrue([
      for def in var.s3_job_definition.bucket_definitions : can(regex("^\\d{12}$", def.account_id))
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition bucket_definitions account_id must be a valid 12-digit AWS account ID."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.bucket_definitions == null || alltrue([
      for def in var.s3_job_definition.bucket_definitions : length(def.buckets) > 0
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition bucket_definitions buckets list cannot be empty."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.scoping == null || var.s3_job_definition.scoping.excludes == null || var.s3_job_definition.scoping.excludes.and == null || alltrue([
      for item in var.s3_job_definition.scoping.excludes.and : alltrue([
        for term in(item.simple_scope_term != null ? [item.simple_scope_term] : []) : term.comparator == null || contains(["EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"], term.comparator)
      ])
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition scoping simple_scope_term comparator must be one of: EQ, GT, GTE, LT, LTE, NE, CONTAINS, STARTS_WITH."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.scoping == null || var.s3_job_definition.scoping.includes == null || var.s3_job_definition.scoping.includes.and == null || alltrue([
      for item in var.s3_job_definition.scoping.includes.and : alltrue([
        for term in(item.simple_scope_term != null ? [item.simple_scope_term] : []) : term.comparator == null || contains(["EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"], term.comparator)
      ])
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition scoping simple_scope_term comparator must be one of: EQ, GT, GTE, LT, LTE, NE, CONTAINS, STARTS_WITH."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.scoping == null || var.s3_job_definition.scoping.excludes == null || var.s3_job_definition.scoping.excludes.and == null || alltrue([
      for item in var.s3_job_definition.scoping.excludes.and : alltrue([
        for term in(item.tag_scope_term != null ? [item.tag_scope_term] : []) : term.key == "TAG"
      ])
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition scoping tag_scope_term key must be 'TAG'."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.scoping == null || var.s3_job_definition.scoping.includes == null || var.s3_job_definition.scoping.includes.and == null || alltrue([
      for item in var.s3_job_definition.scoping.includes.and : alltrue([
        for term in(item.tag_scope_term != null ? [item.tag_scope_term] : []) : term.key == "TAG"
      ])
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition scoping tag_scope_term key must be 'TAG'."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.scoping == null || var.s3_job_definition.scoping.excludes == null || var.s3_job_definition.scoping.excludes.and == null || alltrue([
      for item in var.s3_job_definition.scoping.excludes.and : alltrue([
        for term in(item.tag_scope_term != null ? [item.tag_scope_term] : []) : term.target == "S3_OBJECT"
      ])
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition scoping tag_scope_term target must be 'S3_OBJECT'."
  }

  validation {
    condition = var.s3_job_definition == null || var.s3_job_definition.scoping == null || var.s3_job_definition.scoping.includes == null || var.s3_job_definition.scoping.includes.and == null || alltrue([
      for item in var.s3_job_definition.scoping.includes.and : alltrue([
        for term in(item.tag_scope_term != null ? [item.tag_scope_term] : []) : term.target == "S3_OBJECT"
      ])
    ])
    error_message = "resource_aws_macie2_classification_job, s3_job_definition scoping tag_scope_term target must be 'S3_OBJECT'."
  }
}