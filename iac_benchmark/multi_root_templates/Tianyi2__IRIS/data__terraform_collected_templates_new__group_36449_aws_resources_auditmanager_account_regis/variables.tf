variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "delegated_admin_account" {
  description = "Identifier for the delegated administrator account."
  type        = string
  default     = null
}

variable "deregister_on_destroy" {
  description = "Flag to deregister AuditManager in the account upon destruction. Defaults to false (ie. AuditManager will remain active in the account, even if this resource is removed)."
  type        = bool
  default     = false
}

variable "kms_key" {
  description = "KMS key identifier."
  type        = string
  default     = null
}