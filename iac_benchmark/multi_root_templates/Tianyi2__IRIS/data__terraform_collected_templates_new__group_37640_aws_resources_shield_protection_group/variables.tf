variable "aggregation" {
  description = "Defines how AWS Shield combines resource data for the group in order to detect, mitigate, and report events"
  type        = string

  validation {
    condition     = contains(["SUM", "MEAN", "MAX"], var.aggregation)
    error_message = "resource_aws_shield_protection_group, aggregation must be one of: SUM, MEAN, MAX"
  }
}

variable "members" {
  description = "The Amazon Resource Names (ARNs) of the resources to include in the protection group. You must set this when you set pattern to ARBITRARY and you must not set it for any other pattern setting"
  type        = list(string)
  default     = null

  validation {
    condition     = var.members == null || length(var.members) > 0
    error_message = "resource_aws_shield_protection_group, members must be null or contain at least one ARN"
  }
}

variable "pattern" {
  description = "The criteria to use to choose the protected resources for inclusion in the group"
  type        = string

  validation {
    condition     = contains(["ALL", "ARBITRARY", "BY_RESOURCE_TYPE"], var.pattern)
    error_message = "resource_aws_shield_protection_group, pattern must be one of: ALL, ARBITRARY, BY_RESOURCE_TYPE"
  }

  validation {
    condition     = var.pattern != "ARBITRARY" || var.members != null
    error_message = "resource_aws_shield_protection_group, pattern when set to ARBITRARY, members must be provided"
  }

  validation {
    condition     = var.pattern == "ARBITRARY" || var.members == null
    error_message = "resource_aws_shield_protection_group, pattern when not set to ARBITRARY, members must be null"
  }
}

variable "protection_group_id" {
  description = "The name of the protection group"
  type        = string

  validation {
    condition     = length(var.protection_group_id) > 0
    error_message = "resource_aws_shield_protection_group, protection_group_id cannot be empty"
  }
}

variable "resource_type" {
  description = "The resource type to include in the protection group. You must set this when you set pattern to BY_RESOURCE_TYPE and you must not set it for any other pattern setting"
  type        = string
  default     = null

  validation {
    condition = var.resource_type == null || contains([
      "CLOUDFRONT_DISTRIBUTION",
      "ROUTE_53_HOSTED_ZONE",
      "ELASTIC_IP_ALLOCATION",
      "CLASSIC_LOAD_BALANCER",
      "APPLICATION_LOAD_BALANCER",
      "GLOBAL_ACCELERATOR"
    ], var.resource_type)
    error_message = "resource_aws_shield_protection_group, resource_type must be one of: CLOUDFRONT_DISTRIBUTION, ROUTE_53_HOSTED_ZONE, ELASTIC_IP_ALLOCATION, CLASSIC_LOAD_BALANCER, APPLICATION_LOAD_BALANCER, GLOBAL_ACCELERATOR"
  }

  validation {
    condition     = var.pattern != "BY_RESOURCE_TYPE" || var.resource_type != null
    error_message = "resource_aws_shield_protection_group, resource_type when pattern is set to BY_RESOURCE_TYPE, resource_type must be provided"
  }

  validation {
    condition     = var.pattern == "BY_RESOURCE_TYPE" || var.resource_type == null
    error_message = "resource_aws_shield_protection_group, resource_type when pattern is not set to BY_RESOURCE_TYPE, resource_type must be null"
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}