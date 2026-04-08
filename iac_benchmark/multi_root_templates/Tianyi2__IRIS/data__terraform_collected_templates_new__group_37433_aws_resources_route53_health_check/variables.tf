variable "reference_name" {
  description = "This is a reference name used in Caller Reference (helpful for identifying single health_check set amongst others)"
  type        = string
  default     = null
}

variable "fqdn" {
  description = "The fully qualified domain name of the endpoint to be checked. If a value is set for ip_address, the value set for fqdn will be passed in the Host header"
  type        = string
  default     = null
}

variable "ip_address" {
  description = "The IP address of the endpoint to be checked"
  type        = string
  default     = null
}

variable "port" {
  description = "The port of the endpoint to be checked"
  type        = number
  default     = null
}

variable "type" {
  description = "The protocol to use when performing health checks"
  type        = string
  validation {
    condition = contains([
      "HTTP", "HTTPS", "HTTP_STR_MATCH", "HTTPS_STR_MATCH",
      "TCP", "CALCULATED", "CLOUDWATCH_METRIC", "RECOVERY_CONTROL"
    ], var.type)
    error_message = "resource_aws_route53_health_check, type must be one of: HTTP, HTTPS, HTTP_STR_MATCH, HTTPS_STR_MATCH, TCP, CALCULATED, CLOUDWATCH_METRIC, RECOVERY_CONTROL."
  }
}

variable "failure_threshold" {
  description = "The number of consecutive health checks that an endpoint must pass or fail"
  type        = number
  default     = null
}

variable "request_interval" {
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request"
  type        = number
}

variable "resource_path" {
  description = "The path that you want Amazon Route 53 to request when performing health checks"
  type        = string
  default     = null
}

variable "search_string" {
  description = "String searched in the first 5120 bytes of the response body for check to be considered healthy. Only valid with HTTP_STR_MATCH and HTTPS_STR_MATCH"
  type        = string
  default     = null
  validation {
    condition     = var.search_string == null || var.type == "HTTP_STR_MATCH" || var.type == "HTTPS_STR_MATCH"
    error_message = "resource_aws_route53_health_check, search_string is only valid with HTTP_STR_MATCH and HTTPS_STR_MATCH types."
  }
}

variable "measure_latency" {
  description = "A Boolean value that indicates whether you want Route 53 to measure the latency between health checkers in multiple AWS regions and your endpoint and to display CloudWatch latency graphs in the Route 53 console"
  type        = bool
  default     = null
}

variable "invert_healthcheck" {
  description = "A boolean value that indicates whether the status of health check should be inverted. For example, if a health check is healthy but Inverted is True, then Route 53 considers the health check to be unhealthy"
  type        = bool
  default     = null
}

variable "disabled" {
  description = "A boolean value that stops Route 53 from performing health checks. When set to true, Route 53 will do the following depending on the type of health check"
  type        = bool
  default     = null
}

variable "enable_sni" {
  description = "A boolean value that indicates whether Route53 should send the fqdn to the endpoint when performing the health check. This defaults to AWS' defaults: when the type is HTTPS enable_sni defaults to true, when type is anything else enable_sni defaults to false"
  type        = bool
  default     = null
}

variable "child_healthchecks" {
  description = "For a specified parent health check, a list of HealthCheckId values for the associated child health checks"
  type        = list(string)
  default     = null
}

variable "child_health_threshold" {
  description = "The minimum number of child health checks that must be healthy for Route 53 to consider the parent health check to be healthy"
  type        = number
  default     = null
  validation {
    condition     = var.child_health_threshold == null || (var.child_health_threshold >= 0 && var.child_health_threshold <= 256)
    error_message = "resource_aws_route53_health_check, child_health_threshold must be an integer between 0 and 256, inclusive."
  }
}

variable "cloudwatch_alarm_name" {
  description = "The name of the CloudWatch alarm"
  type        = string
  default     = null
}

variable "cloudwatch_alarm_region" {
  description = "The region that the CloudWatch alarm was created in"
  type        = string
  default     = null
}

variable "insufficient_data_health_status" {
  description = "The status of the health check when CloudWatch has insufficient data about the state of associated alarm"
  type        = string
  default     = null
  validation {
    condition = var.insufficient_data_health_status == null || contains([
      "Healthy", "Unhealthy", "LastKnownStatus"
    ], var.insufficient_data_health_status)
    error_message = "resource_aws_route53_health_check, insufficient_data_health_status must be one of: Healthy, Unhealthy, LastKnownStatus."
  }
}

variable "regions" {
  description = "A list of AWS regions that you want Amazon Route 53 health checkers to check the specified endpoint from"
  type        = list(string)
  default     = null
}

variable "routing_control_arn" {
  description = "The Amazon Resource Name (ARN) for the Route 53 Application Recovery Controller routing control. This is used when health check type is RECOVERY_CONTROL"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the health check. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger an in-place update of the CloudWatch alarm arguments. Use this argument to synchronize the health check when an alarm is changed"
  type        = map(string)
  default     = null
}