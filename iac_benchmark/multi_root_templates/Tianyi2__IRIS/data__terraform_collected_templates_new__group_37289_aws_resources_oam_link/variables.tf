variable "label_template" {
  description = "Human-readable name to use to identify this source account when you are viewing data from it in the monitoring account."
  type        = string

  validation {
    condition     = length(var.label_template) > 0
    error_message = "resource_aws_oam_link, label_template must not be empty."
  }
}

variable "resource_types" {
  description = "Types of data that the source account shares with the monitoring account."
  type        = list(string)

  validation {
    condition     = length(var.resource_types) > 0
    error_message = "resource_aws_oam_link, resource_types must contain at least one element."
  }

  validation {
    condition = alltrue([
      for rt in var.resource_types : contains([
        "AWS::CloudWatch::Metric",
        "AWS::Logs::LogGroup",
        "AWS::XRay::Trace",
        "AWS::ApplicationInsights::Application",
        "AWS::InternetMonitor::Monitor"
      ], rt)
    ])
    error_message = "resource_aws_oam_link, resource_types must contain valid AWS resource types."
  }
}

variable "sink_identifier" {
  description = "Identifier of the sink to use to create this link."
  type        = string

  validation {
    condition     = length(var.sink_identifier) > 0
    error_message = "resource_aws_oam_link, sink_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "link_configuration" {
  description = "Configuration for creating filters that specify that only some metric namespaces or log groups are to be shared from the source account to the monitoring account."
  type = object({
    log_group_configuration = optional(object({
      filter = string
    }))
    metric_configuration = optional(object({
      filter = string
    }))
  })
  default = null

  validation {
    condition = var.link_configuration == null ? true : (
      var.link_configuration.log_group_configuration != null ? length(var.link_configuration.log_group_configuration.filter) > 0 : true
    )
    error_message = "resource_aws_oam_link, link_configuration.log_group_configuration.filter must not be empty when specified."
  }

  validation {
    condition = var.link_configuration == null ? true : (
      var.link_configuration.metric_configuration != null ? length(var.link_configuration.metric_configuration.filter) > 0 : true
    )
    error_message = "resource_aws_oam_link, link_configuration.metric_configuration.filter must not be empty when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration for timeouts."
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
    delete = optional(string, "1m")
  })
  default = {
    create = "1m"
    update = "1m"
    delete = "1m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_oam_link, timeouts.create must be a valid duration (e.g., '1m', '30s', '1h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.update))
    error_message = "resource_aws_oam_link, timeouts.update must be a valid duration (e.g., '1m', '30s', '1h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_oam_link, timeouts.delete must be a valid duration (e.g., '1m', '30s', '1h')."
  }
}