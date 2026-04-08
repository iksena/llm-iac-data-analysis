variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_account_settings, aws_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "default_namespace" {
  description = "The default namespace for this Amazon Web Services account. Currently, the default is 'default'."
  type        = string
  default     = "default"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.default_namespace))
    error_message = "resource_aws_quicksight_account_settings, default_namespace must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "termination_protection_enabled" {
  description = "A boolean value that determines whether or not an Amazon QuickSight account can be deleted. If true, it does not allow the account to be deleted and results in an error message if a user tries to make a DeleteAccountSubscription request. If false, it will allow the account to be deleted."
  type        = bool
  default     = null

  validation {
    condition     = var.termination_protection_enabled == null || can(tobool(var.termination_protection_enabled))
    error_message = "resource_aws_quicksight_account_settings, termination_protection_enabled must be a boolean value (true or false)."
  }
}