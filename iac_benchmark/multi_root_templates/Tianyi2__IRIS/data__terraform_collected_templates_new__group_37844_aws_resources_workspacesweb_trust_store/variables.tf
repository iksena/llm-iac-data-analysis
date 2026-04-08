variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificates" {
  description = "Set of certificates to include in the trust store."
  type = list(object({
    body = string
  }))
  default = []

  validation {
    condition = alltrue([
      for cert in var.certificates : cert.body != null && cert.body != ""
    ])
    error_message = "resource_aws_workspacesweb_trust_store, certificates: Certificate body cannot be null or empty."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags) && var.tags != null
    error_message = "resource_aws_workspacesweb_trust_store, tags: Tags must be a valid map of strings."
  }
}