variable "name" {
  description = "The name of the app monitor"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "app_monitor_configuration" {
  description = "Configuration data for the app monitor"
  type = object({
    allow_cookies       = optional(bool)
    domain              = optional(string)
    domain_list         = optional(list(string))
    enable_xray         = optional(bool)
    excluded_pages      = optional(list(string))
    favorite_pages      = optional(list(string))
    guest_role_arn      = optional(string)
    identity_pool_id    = optional(string)
    included_pages      = optional(list(string))
    session_sample_rate = optional(number, 0.1)
    telemetries         = optional(list(string))
  })
  default = null

  validation {
    condition = var.app_monitor_configuration == null ? true : (
      var.app_monitor_configuration.domain != null && var.app_monitor_configuration.domain_list != null ? false :
      var.app_monitor_configuration.domain == null && var.app_monitor_configuration.domain_list == null ? false : true
    )
    error_message = "resource_aws_rum_app_monitor, app_monitor_configuration: exactly one of domain or domain_list must be specified."
  }

  validation {
    condition = var.app_monitor_configuration == null ? true : (
      var.app_monitor_configuration.telemetries == null ? true :
      alltrue([for t in var.app_monitor_configuration.telemetries : contains(["errors", "performance", "http"], t)])
    )
    error_message = "resource_aws_rum_app_monitor, app_monitor_configuration.telemetries: valid values are errors, performance, and http."
  }

  validation {
    condition = var.app_monitor_configuration == null ? true : (
      var.app_monitor_configuration.session_sample_rate == null ? true :
      var.app_monitor_configuration.session_sample_rate >= 0 && var.app_monitor_configuration.session_sample_rate <= 1
    )
    error_message = "resource_aws_rum_app_monitor, app_monitor_configuration.session_sample_rate: must be between 0 and 1."
  }
}

variable "cw_log_enabled" {
  description = "Specifies whether RUM sends a copy of telemetry data to Amazon CloudWatch Logs"
  type        = bool
  default     = false
}

variable "custom_events" {
  description = "Specifies whether this app monitor allows the web client to define and send custom events"
  type = object({
    status = optional(string, "DISABLED")
  })
  default = null

  validation {
    condition = var.custom_events == null ? true : (
      var.custom_events.status == null ? true :
      contains(["DISABLED", "ENABLED"], var.custom_events.status)
    )
    error_message = "resource_aws_rum_app_monitor, custom_events.status: valid values are DISABLED and ENABLED."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}