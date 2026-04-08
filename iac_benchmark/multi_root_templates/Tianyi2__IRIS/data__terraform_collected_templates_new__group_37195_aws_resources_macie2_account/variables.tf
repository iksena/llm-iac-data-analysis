variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "finding_publishing_frequency" {
  description = "Specifies how often to publish updates to policy findings for the account. This includes publishing updates to AWS Security Hub and Amazon EventBridge (formerly called Amazon CloudWatch Events)."
  type        = string
  default     = null

  validation {
    condition     = var.finding_publishing_frequency == null || contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "resource_aws_macie2_account, finding_publishing_frequency must be one of: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS."
  }
}

variable "status" {
  description = "Specifies the status for the account. To enable Amazon Macie and start all Macie activities for the account, set this value to ENABLED."
  type        = string
  default     = null

  validation {
    condition     = var.status == null || contains(["ENABLED", "PAUSED"], var.status)
    error_message = "resource_aws_macie2_account, status must be one of: ENABLED, PAUSED."
  }
}