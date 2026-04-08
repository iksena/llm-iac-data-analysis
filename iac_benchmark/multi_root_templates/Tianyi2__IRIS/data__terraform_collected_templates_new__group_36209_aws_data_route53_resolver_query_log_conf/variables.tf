variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_route53_resolver_query_log_config, region must be a valid AWS region format."
  }
}

variable "resolver_query_log_config_id" {
  description = "ID of the Route53 Resolver Query Logging Configuration."
  type        = string
  default     = null

  validation {
    condition     = var.resolver_query_log_config_id == null || can(regex("^rqlc-[0-9a-z]+$", var.resolver_query_log_config_id))
    error_message = "data_aws_route53_resolver_query_log_config, resolver_query_log_config_id must be a valid Route53 resolver query log config ID format (rqlc-xxxxxx)."
  }
}

variable "filter" {
  description = "One or more name/value pairs to use as filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && length(f.name) > 0
    ])
    error_message = "data_aws_route53_resolver_query_log_config, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_route53_resolver_query_log_config, filter values must contain at least one value."
  }
}