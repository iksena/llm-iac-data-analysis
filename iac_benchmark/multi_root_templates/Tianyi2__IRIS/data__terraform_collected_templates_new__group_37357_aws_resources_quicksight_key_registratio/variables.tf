variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_key_registration, aws_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_key_registration, region must be a valid AWS region name."
  }
}

variable "key_registration" {
  description = "Registered keys configuration."
  type = list(object({
    default_key = optional(bool, false)
    key_arn     = string
  }))

  validation {
    condition     = length(var.key_registration) > 0
    error_message = "resource_aws_quicksight_key_registration, key_registration must contain at least one key registration."
  }

  validation {
    condition = alltrue([
      for kr in var.key_registration :
      can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", kr.key_arn))
    ])
    error_message = "resource_aws_quicksight_key_registration, key_registration key_arn must be a valid AWS KMS key ARN."
  }

  validation {
    condition = length([
      for kr in var.key_registration :
      kr if kr.default_key == true
    ]) <= 1
    error_message = "resource_aws_quicksight_key_registration, key_registration can have at most one key marked as default_key."
  }
}