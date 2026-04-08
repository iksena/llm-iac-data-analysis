variable "additional_encryption_context" {
  description = "Additional encryption context for the customer managed key. Forces replacement if changed."
  type        = map(string)
  default     = null
}

variable "authentication_type" {
  description = "Authentication type for the portal."
  type        = string
  default     = null

  validation {
    condition     = var.authentication_type == null || contains(["Standard", "IAM_Identity_Center"], var.authentication_type)
    error_message = "resource_aws_workspacesweb_portal, authentication_type must be one of: Standard, IAM_Identity_Center."
  }
}

variable "browser_settings_arn" {
  description = "ARN of the browser settings to use for the portal."
  type        = string
  default     = null

  validation {
    condition     = var.browser_settings_arn == null || can(regex("^arn:aws:workspaces-web:[a-z0-9-]+:[0-9]{12}:browserSettings/[a-zA-Z0-9-]+$", var.browser_settings_arn))
    error_message = "resource_aws_workspacesweb_portal, browser_settings_arn must be a valid ARN for WorkSpaces Web browser settings."
  }
}

variable "customer_managed_key" {
  description = "ARN of the customer managed key. Forces replacement if changed."
  type        = string
  default     = null

  validation {
    condition     = var.customer_managed_key == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.customer_managed_key))
    error_message = "resource_aws_workspacesweb_portal, customer_managed_key must be a valid KMS key ARN."
  }
}

variable "display_name" {
  description = "Display name of the portal."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type for the portal."
  type        = string
  default     = null

  validation {
    condition     = var.instance_type == null || contains(["standard.regular", "standard.large"], var.instance_type)
    error_message = "resource_aws_workspacesweb_portal, instance_type must be one of: standard.regular, standard.large."
  }
}

variable "max_concurrent_sessions" {
  description = "Maximum number of concurrent sessions for the portal."
  type        = number
  default     = null

  validation {
    condition     = var.max_concurrent_sessions == null || (var.max_concurrent_sessions > 0 && var.max_concurrent_sessions <= 1000)
    error_message = "resource_aws_workspacesweb_portal, max_concurrent_sessions must be between 1 and 1000."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {}
}