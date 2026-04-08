variable "auto_renew" {
  description = "Toggle for automated renewal of the subscription. Valid values are ENABLED or DISABLED."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.auto_renew)
    error_message = "resource_aws_shield_subscription, auto_renew must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "skip_destroy" {
  description = "Skip attempting to disable automated renewal upon destruction. If set to true, the auto_renew value will be left as-is and the resource will simply be removed from state."
  type        = bool
  default     = null
}