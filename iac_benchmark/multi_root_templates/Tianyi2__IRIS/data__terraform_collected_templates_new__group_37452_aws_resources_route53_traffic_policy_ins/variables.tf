variable "name" {
  description = "Domain name for which Amazon Route 53 responds to DNS queries by using the resource record sets that Route 53 creates for this traffic policy instance."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+$", var.name))
    error_message = "resource_aws_route53_traffic_policy_instance, name must be a valid domain name containing only alphanumeric characters, dots, and hyphens."
  }
}

variable "traffic_policy_id" {
  description = "ID of the traffic policy that you want to use to create resource record sets in the specified hosted zone."
  type        = string

  validation {
    condition     = length(var.traffic_policy_id) > 0
    error_message = "resource_aws_route53_traffic_policy_instance, traffic_policy_id cannot be empty."
  }
}

variable "traffic_policy_version" {
  description = "Version of the traffic policy"
  type        = number

  validation {
    condition     = var.traffic_policy_version > 0
    error_message = "resource_aws_route53_traffic_policy_instance, traffic_policy_version must be a positive integer."
  }
}

variable "hosted_zone_id" {
  description = "ID of the hosted zone that you want Amazon Route 53 to create resource record sets in by using the configuration in a traffic policy."
  type        = string

  validation {
    condition     = length(var.hosted_zone_id) > 0
    error_message = "resource_aws_route53_traffic_policy_instance, hosted_zone_id cannot be empty."
  }
}

variable "ttl" {
  description = "TTL that you want Amazon Route 53 to assign to all the resource record sets that it creates in the specified hosted zone."
  type        = number

  validation {
    condition     = var.ttl >= 0 && var.ttl <= 2147483647
    error_message = "resource_aws_route53_traffic_policy_instance, ttl must be between 0 and 2147483647 seconds."
  }
}