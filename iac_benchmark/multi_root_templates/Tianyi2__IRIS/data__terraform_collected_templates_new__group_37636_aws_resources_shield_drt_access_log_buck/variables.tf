variable "log_bucket" {
  description = "The Amazon S3 bucket that contains the logs that you want to share."
  type        = string

  validation {
    condition     = length(var.log_bucket) > 0
    error_message = "resource_aws_shield_drt_access_log_bucket_association, log_bucket must not be empty."
  }
}

variable "role_arn_association_id" {
  description = "The ID of the Role Arn association used for allowing Shield DRT Access."
  type        = string

  validation {
    condition     = length(var.role_arn_association_id) > 0
    error_message = "resource_aws_shield_drt_access_log_bucket_association, role_arn_association_id must not be empty."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the resource."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.timeouts_create))
    error_message = "resource_aws_shield_drt_access_log_bucket_association, timeouts_create must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the resource."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.timeouts_delete))
    error_message = "resource_aws_shield_drt_access_log_bucket_association, timeouts_delete must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}