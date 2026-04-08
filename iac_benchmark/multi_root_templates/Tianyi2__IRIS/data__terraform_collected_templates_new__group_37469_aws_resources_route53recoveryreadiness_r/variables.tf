variable "resource_set_name" {
  description = "Unique name describing the resource set"
  type        = string

  validation {
    condition     = length(var.resource_set_name) > 0
    error_message = "resource_aws_route53recoveryreadiness_resource_set, resource_set_name must be a non-empty string."
  }
}

variable "resource_set_type" {
  description = "Type of the resources in the resource set"
  type        = string

  validation {
    condition     = length(var.resource_set_type) > 0
    error_message = "resource_aws_route53recoveryreadiness_resource_set, resource_set_type must be a non-empty string."
  }
}

variable "resources" {
  description = "List of resources to add to this resource set"
  type = list(object({
    readiness_scopes = optional(list(string))
    resource_arn     = optional(string)
    dns_target_resource = optional(object({
      domain_name     = optional(string)
      hosted_zone_arn = optional(string)
      record_set_id   = optional(string)
      record_type     = optional(string)
      target_resource = optional(object({
        nlb_resource = optional(object({
          arn = string
        }))
        r53_resource = optional(object({
          domain_name   = optional(string)
          record_set_id = optional(string)
        }))
      }))
    }))
  }))

  validation {
    condition     = length(var.resources) > 0
    error_message = "resource_aws_route53recoveryreadiness_resource_set, resources must contain at least one resource."
  }

  validation {
    condition = alltrue([
      for resource in var.resources :
      (resource.resource_arn != null && resource.dns_target_resource == null) ||
      (resource.resource_arn == null && resource.dns_target_resource != null)
    ])
    error_message = "resource_aws_route53recoveryreadiness_resource_set, resources each resource must have either resource_arn or dns_target_resource set, but not both."
  }

  validation {
    condition = alltrue([
      for resource in var.resources :
      resource.dns_target_resource == null ? true : (
        resource.dns_target_resource.target_resource == null ? true : (
          (resource.dns_target_resource.target_resource.nlb_resource != null && resource.dns_target_resource.target_resource.r53_resource == null) ||
          (resource.dns_target_resource.target_resource.nlb_resource == null && resource.dns_target_resource.target_resource.r53_resource != null)
        )
      )
    ])
    error_message = "resource_aws_route53recoveryreadiness_resource_set, resources target_resource must have either nlb_resource or r53_resource set, but not both."
  }

  validation {
    condition = alltrue([
      for resource in var.resources :
      resource.dns_target_resource == null ? true : (
        resource.dns_target_resource.target_resource == null ? true : (
          resource.dns_target_resource.target_resource.nlb_resource == null ? true :
          resource.dns_target_resource.target_resource.nlb_resource.arn != null
        )
      )
    ])
    error_message = "resource_aws_route53recoveryreadiness_resource_set, resources nlb_resource.arn is required when nlb_resource is specified."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "delete_timeout" {
  description = "Delete timeout for the resource"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_route53recoveryreadiness_resource_set, delete_timeout must be a valid duration string (e.g., '5m', '30s', '1h')."
  }
}