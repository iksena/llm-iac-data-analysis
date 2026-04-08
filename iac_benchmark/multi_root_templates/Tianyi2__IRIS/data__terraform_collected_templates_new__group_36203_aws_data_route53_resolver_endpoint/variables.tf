variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_route53_resolver_endpoint, region must be a valid AWS region identifier or null."
  }
}

variable "resolver_endpoint_id" {
  description = "ID of the Route53 Resolver Endpoint."
  type        = string
  default     = null

  validation {
    condition     = var.resolver_endpoint_id == null || can(regex("^rslvr-(in|out)-[0-9a-z]+$", var.resolver_endpoint_id))
    error_message = "data_aws_route53_resolver_endpoint, resolver_endpoint_id must be a valid resolver endpoint ID starting with 'rslvr-in-' or 'rslvr-out-' or null."
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
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_route53_resolver_endpoint, filter name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_route53_resolver_endpoint, filter values must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_route53_resolver_endpoint, filter values must be non-empty strings."
  }
}