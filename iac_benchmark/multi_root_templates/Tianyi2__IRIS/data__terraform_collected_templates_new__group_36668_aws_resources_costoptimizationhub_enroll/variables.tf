variable "include_member_accounts" {
  description = "Flag to enroll member accounts of the organization if the account is the management account. No drift detection is currently supported for this argument."
  type        = bool
  default     = false

  validation {
    condition     = can(var.include_member_accounts)
    error_message = "resource_aws_costoptimizationhub_enrollment_status, include_member_accounts must be a boolean value."
  }
}