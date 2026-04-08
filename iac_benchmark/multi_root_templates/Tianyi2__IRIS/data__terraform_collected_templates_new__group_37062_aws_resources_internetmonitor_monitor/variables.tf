variable "monitor_name" {
  description = "The name of the monitor."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.monitor_name))
    error_message = "resource_aws_internetmonitor_monitor, monitor_name must contain only alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "health_events_config" {
  description = "Health event thresholds. A health event threshold percentage, for performance and availability, determines when Internet Monitor creates a health event when there's an internet issue that affects your application end users."
  type = object({
    availability_score_threshold = optional(number)
    performance_score_threshold  = optional(number)
  })
  default = null
  validation {
    condition = var.health_events_config == null || (
      (var.health_events_config.availability_score_threshold == null || (var.health_events_config.availability_score_threshold >= 0 && var.health_events_config.availability_score_threshold <= 100)) &&
      (var.health_events_config.performance_score_threshold == null || (var.health_events_config.performance_score_threshold >= 0 && var.health_events_config.performance_score_threshold <= 100))
    )
    error_message = "resource_aws_internetmonitor_monitor, health_events_config thresholds must be between 0 and 100 percent."
  }
}

variable "internet_measurements_log_delivery" {
  description = "Publish internet measurements for Internet Monitor to an Amazon S3 bucket in addition to CloudWatch Logs."
  type = object({
    s3_config = object({
      bucket_name         = string
      bucket_prefix       = optional(string)
      log_delivery_status = optional(string)
    })
  })
  default = null
  validation {
    condition = var.internet_measurements_log_delivery == null || (
      can(regex("^[a-z0-9.-]+$", var.internet_measurements_log_delivery.s3_config.bucket_name))
    )
    error_message = "resource_aws_internetmonitor_monitor, internet_measurements_log_delivery s3_config bucket_name must be a valid S3 bucket name."
  }
}

variable "max_city_networks_to_monitor" {
  description = "The maximum number of city-networks to monitor for your resources. A city-network is the location (city) where clients access your application resources from and the network or ASN, such as an internet service provider (ISP), that clients access the resources through. This limit helps control billing costs."
  type        = number
  default     = null
  validation {
    condition     = var.max_city_networks_to_monitor == null || (var.max_city_networks_to_monitor >= 1 && var.max_city_networks_to_monitor <= 500000)
    error_message = "resource_aws_internetmonitor_monitor, max_city_networks_to_monitor must be between 1 and 500000."
  }
}

variable "resources" {
  description = "The resources to include in a monitor, which you provide as a set of Amazon Resource Names (ARNs)."
  type        = set(string)
  default     = null
  validation {
    condition = var.resources == null || length(var.resources) == 0 || alltrue([
      for arn in var.resources : can(regex("^arn:aws[a-zA-Z-]*:[a-zA-Z0-9-]+:[a-zA-Z0-9-]*:[0-9]{12}:.+$", arn))
    ])
    error_message = "resource_aws_internetmonitor_monitor, resources must be valid AWS ARNs."
  }
}

variable "status" {
  description = "The status for a monitor. The accepted values for Status with the UpdateMonitor API call are the following: ACTIVE and INACTIVE."
  type        = string
  default     = null
  validation {
    condition     = var.status == null || contains(["ACTIVE", "INACTIVE"], var.status)
    error_message = "resource_aws_internetmonitor_monitor, status must be either ACTIVE or INACTIVE."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "traffic_percentage_to_monitor" {
  description = "The percentage of the internet-facing traffic for your application that you want to monitor with this monitor."
  type        = number
  default     = null
  validation {
    condition     = var.traffic_percentage_to_monitor == null || (var.traffic_percentage_to_monitor >= 1 && var.traffic_percentage_to_monitor <= 100)
    error_message = "resource_aws_internetmonitor_monitor, traffic_percentage_to_monitor must be between 1 and 100 percent."
  }
}