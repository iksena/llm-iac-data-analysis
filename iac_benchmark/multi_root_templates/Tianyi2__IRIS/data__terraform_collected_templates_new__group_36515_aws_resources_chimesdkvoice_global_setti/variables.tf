variable "cdr_bucket" {
  description = "The S3 bucket that stores the Voice Connector's call detail records"
  type        = string
  default     = null

  validation {
    condition     = var.cdr_bucket == null || can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.cdr_bucket))
    error_message = "resource_aws_chimesdkvoice_global_settings, cdr_bucket must be a valid S3 bucket name (3-63 characters, lowercase alphanumeric and hyphens, start and end with alphanumeric)."
  }
}