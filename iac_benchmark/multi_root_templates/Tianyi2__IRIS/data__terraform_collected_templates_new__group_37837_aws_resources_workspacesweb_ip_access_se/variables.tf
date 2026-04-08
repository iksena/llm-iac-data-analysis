variable "display_name" {
  description = "The display name of the IP access settings."
  type        = string

  validation {
    condition     = length(var.display_name) > 0
    error_message = "resource_aws_workspacesweb_ip_access_settings, display_name must not be empty."
  }
}

variable "ip_rules" {
  description = "The IP rules of the IP access settings."
  type = list(object({
    ip_range    = string
    description = optional(string)
  }))

  validation {
    condition     = length(var.ip_rules) > 0
    error_message = "resource_aws_workspacesweb_ip_access_settings, ip_rules must contain at least one IP rule."
  }

  validation {
    condition = alltrue([
      for rule in var.ip_rules : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", rule.ip_range))
    ])
    error_message = "resource_aws_workspacesweb_ip_access_settings, ip_rules must contain valid CIDR notation IP ranges."
  }
}

variable "additional_encryption_context" {
  description = "Additional encryption context for the IP access settings."
  type        = map(string)
  default     = null
}

variable "customer_managed_key" {
  description = "ARN of the customer managed KMS key."
  type        = string
  default     = null

  validation {
    condition     = var.customer_managed_key == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.customer_managed_key))
    error_message = "resource_aws_workspacesweb_ip_access_settings, customer_managed_key must be a valid KMS key ARN."
  }
}

variable "description" {
  description = "The description of the IP access settings."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_workspacesweb_ip_access_settings, region must be a valid AWS region name."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}