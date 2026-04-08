variable "browser_policy" {
  description = "Browser policy for the browser settings. This is a JSON string that defines the browser settings policy."
  type        = string

  validation {
    condition     = can(jsondecode(var.browser_policy))
    error_message = "resource_aws_workspacesweb_browser_settings, browser_policy must be a valid JSON string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "additional_encryption_context" {
  description = "Additional encryption context for the browser settings."
  type        = map(string)
  default     = null
}

variable "customer_managed_key" {
  description = "ARN of the customer managed KMS key."
  type        = string
  default     = null

  validation {
    condition     = var.customer_managed_key == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.customer_managed_key))
    error_message = "resource_aws_workspacesweb_browser_settings, customer_managed_key must be a valid KMS key ARN when provided."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}