variable "description" {
  description = "Description for the experiment template"
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_fis_experiment_template, description must not be empty."
  }
}

variable "role_arn" {
  description = "ARN of an IAM role that grants the AWS FIS service permission to perform service actions on your behalf"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:role/[\\w+=,.@-]+$", var.role_arn))
    error_message = "resource_aws_fis_experiment_template, role_arn must be a valid IAM role ARN."
  }
}

variable "actions" {
  description = "Actions to be performed during an experiment"
  type = list(object({
    name        = string
    action_id   = string
    description = optional(string)
    parameters = optional(list(object({
      key   = string
      value = string
    })))
    start_after = optional(set(string))
    targets = optional(list(object({
      key   = string
      value = string
    })))
  }))

  validation {
    condition     = length(var.actions) > 0
    error_message = "resource_aws_fis_experiment_template, actions must contain at least one action."
  }

  validation {
    condition = alltrue([
      for action in var.actions : length(action.name) > 0
    ])
    error_message = "resource_aws_fis_experiment_template, actions name must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.actions : length(action.action_id) > 0
    ])
    error_message = "resource_aws_fis_experiment_template, actions action_id must not be empty."
  }
}

variable "stop_conditions" {
  description = "When an ongoing experiment should be stopped"
  type = list(object({
    source = string
    value  = optional(string)
  }))

  validation {
    condition     = length(var.stop_conditions) > 0
    error_message = "resource_aws_fis_experiment_template, stop_conditions must contain at least one stop condition."
  }

  validation {
    condition = alltrue([
      for condition in var.stop_conditions : contains(["none", "aws:cloudwatch:alarm"], condition.source)
    ])
    error_message = "resource_aws_fis_experiment_template, stop_conditions source must be one of: none, aws:cloudwatch:alarm."
  }

  validation {
    condition = alltrue([
      for condition in var.stop_conditions :
      condition.source == "none" ? condition.value == null : condition.value != null
    ])
    error_message = "resource_aws_fis_experiment_template, stop_conditions value is required when source is aws:cloudwatch:alarm and must be null when source is none."
  }
}

variable "experiment_options" {
  description = "The experiment options for the experiment template"
  type = object({
    account_targeting            = optional(string)
    empty_target_resolution_mode = optional(string)
  })
  default = null

  validation {
    condition = var.experiment_options == null ? true : (
      var.experiment_options.account_targeting == null ? true : contains(["single-account", "multi-account"], var.experiment_options.account_targeting)
    )
    error_message = "resource_aws_fis_experiment_template, experiment_options account_targeting must be one of: single-account, multi-account."
  }

  validation {
    condition = var.experiment_options == null ? true : (
      var.experiment_options.empty_target_resolution_mode == null ? true : contains(["fail", "skip"], var.experiment_options.empty_target_resolution_mode)
    )
    error_message = "resource_aws_fis_experiment_template, experiment_options empty_target_resolution_mode must be one of: fail, skip."
  }
}

variable "targets" {
  description = "Targets of actions"
  type = list(object({
    name           = string
    resource_type  = string
    selection_mode = string
    resource_arns  = optional(set(string))
    resource_tags = optional(list(object({
      key   = string
      value = string
    })))
    parameters = optional(map(string))
    filters = optional(list(object({
      path   = string
      values = set(string)
    })))
  }))
  default = null

  validation {
    condition = var.targets == null ? true : alltrue([
      for target in var.targets : length(target.name) > 0
    ])
    error_message = "resource_aws_fis_experiment_template, targets name must not be empty."
  }

  validation {
    condition = var.targets == null ? true : alltrue([
      for target in var.targets : length(target.resource_type) > 0
    ])
    error_message = "resource_aws_fis_experiment_template, targets resource_type must not be empty."
  }

  validation {
    condition = var.targets == null ? true : alltrue([
      for target in var.targets : can(regex("^(ALL|COUNT\\(\\d+\\)|PERCENT\\(\\d+\\))$", target.selection_mode))
    ])
    error_message = "resource_aws_fis_experiment_template, targets selection_mode must be ALL, COUNT(n), or PERCENT(n)."
  }

  validation {
    condition = var.targets == null ? true : alltrue([
      for target in var.targets :
      (target.resource_arns != null && target.resource_tags == null) ||
      (target.resource_arns == null && target.resource_tags != null)
    ])
    error_message = "resource_aws_fis_experiment_template, targets must specify either resource_arns or resource_tags, but not both."
  }
}

variable "log_configuration" {
  description = "The configuration for experiment logging"
  type = object({
    log_schema_version = string
    cloudwatch_logs_configuration = optional(object({
      log_group_arn = string
    }))
    s3_configuration = optional(object({
      bucket_name = string
      prefix      = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.log_configuration == null ? true : length(var.log_configuration.log_schema_version) > 0
    error_message = "resource_aws_fis_experiment_template, log_configuration log_schema_version must not be empty."
  }

  validation {
    condition = var.log_configuration == null ? true : (
      var.log_configuration.cloudwatch_logs_configuration == null ? true :
      can(regex("^arn:aws[a-zA-Z-]*:logs:[a-z0-9-]+:\\d{12}:log-group:", var.log_configuration.cloudwatch_logs_configuration.log_group_arn))
    )
    error_message = "resource_aws_fis_experiment_template, log_configuration cloudwatch_logs_configuration log_group_arn must be a valid CloudWatch Logs log group ARN."
  }

  validation {
    condition = var.log_configuration == null ? true : (
      var.log_configuration.s3_configuration == null ? true : length(var.log_configuration.s3_configuration.bucket_name) > 0
    )
    error_message = "resource_aws_fis_experiment_template, log_configuration s3_configuration bucket_name must not be empty."
  }
}

variable "experiment_report_configuration" {
  description = "The configuration for experiment reporting"
  type = object({
    data_sources = object({
      cloudwatch_dashboard = object({
        dashboard_arn = string
      })
    })
    outputs = object({
      s3_configuration = object({
        bucket_name = string
        prefix      = optional(string)
      })
    })
    post_experiment_duration = optional(string)
    pre_experiment_duration  = optional(string)
  })
  default = null

  validation {
    condition     = var.experiment_report_configuration == null ? true : can(regex("^arn:aws[a-zA-Z-]*:cloudwatch:[a-z0-9-]+:\\d{12}:dashboard/", var.experiment_report_configuration.data_sources.cloudwatch_dashboard.dashboard_arn))
    error_message = "resource_aws_fis_experiment_template, experiment_report_configuration data_sources cloudwatch_dashboard dashboard_arn must be a valid CloudWatch dashboard ARN."
  }

  validation {
    condition     = var.experiment_report_configuration == null ? true : length(var.experiment_report_configuration.outputs.s3_configuration.bucket_name) > 0
    error_message = "resource_aws_fis_experiment_template, experiment_report_configuration outputs s3_configuration bucket_name must not be empty."
  }

  validation {
    condition = var.experiment_report_configuration == null ? true : (
      var.experiment_report_configuration.post_experiment_duration == null ? true :
      can(regex("^PT\\d+[HMS]$", var.experiment_report_configuration.post_experiment_duration))
    )
    error_message = "resource_aws_fis_experiment_template, experiment_report_configuration post_experiment_duration must be in ISO 8601 duration format (e.g., PT10M)."
  }

  validation {
    condition = var.experiment_report_configuration == null ? true : (
      var.experiment_report_configuration.pre_experiment_duration == null ? true :
      can(regex("^PT\\d+[HMS]$", var.experiment_report_configuration.pre_experiment_duration))
    )
    error_message = "resource_aws_fis_experiment_template, experiment_report_configuration pre_experiment_duration must be in ISO 8601 duration format (e.g., PT10M)."
  }
}

variable "tags" {
  description = "Key-value mapping of tags"
  type        = map(string)
  default     = {}
}