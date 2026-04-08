variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bundle_id" {
  description = "ID of the bundle."
  type        = string
  default     = null
}

variable "owner" {
  description = "Owner of the bundles. You have to leave it blank for own bundles. You cannot combine this parameter with bundle_id."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the bundle. You cannot combine this parameter with bundle_id."
  type        = string
  default     = null
}