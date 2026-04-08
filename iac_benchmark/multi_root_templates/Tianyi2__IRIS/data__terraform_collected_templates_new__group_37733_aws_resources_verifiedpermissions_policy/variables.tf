variable "validation_mode" {
  description = "The mode for the validation settings"
  type        = string
  validation {
    condition     = contains(["OFF", "STRICT"], var.validation_mode)
    error_message = "resource_aws_verifiedpermissions_policy_store, validation_mode must be one of: OFF, STRICT."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Specifies whether the policy store can be deleted"
  type        = string
  default     = "DISABLED"
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.deletion_protection)
    error_message = "resource_aws_verifiedpermissions_policy_store, deletion_protection must be one of: ENABLED, DISABLED."
  }
}

variable "description" {
  description = "A description of the Policy Store"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}