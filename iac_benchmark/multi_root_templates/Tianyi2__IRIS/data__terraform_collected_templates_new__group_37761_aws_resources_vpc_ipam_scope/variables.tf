variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "ipam_id" {
  description = "The ID of the IPAM for which you're creating this scope."
  type        = string

  validation {
    condition     = can(regex("^ipam-[0-9a-f]{17}$", var.ipam_id))
    error_message = "resource_aws_vpc_ipam_scope, ipam_id must be a valid IPAM ID format (ipam-xxxxxxxxxxxxxxxxx)."
  }
}

variable "description" {
  description = "A description for the scope you're creating."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 255
    error_message = "resource_aws_vpc_ipam_scope, description must be 255 characters or less."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}