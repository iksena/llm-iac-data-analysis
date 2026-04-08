variable "email" {
  description = "Email address of the user that you want to register"
  type        = string
}

variable "identity_type" {
  description = "Identity type that your Amazon QuickSight account uses to manage the identity of users"
  type        = string

  validation {
    condition = contains([
      "IAM",
      "QUICKSIGHT",
      "IAM_IDENTITY_CENTER"
    ], var.identity_type)
    error_message = "resource_aws_quicksight_user, identity_type must be one of: IAM, QUICKSIGHT, IAM_IDENTITY_CENTER."
  }
}

variable "user_role" {
  description = "Amazon QuickSight role for the user"
  type        = string

  validation {
    condition = contains([
      "READER",
      "AUTHOR",
      "ADMIN",
      "READER_PRO",
      "AUTHOR_PRO",
      "ADMIN_PRO",
      "RESTRICTED_AUTHOR",
      "RESTRICTED_READER"
    ], var.user_role)
    error_message = "resource_aws_quicksight_user, user_role must be one of: READER, AUTHOR, ADMIN, READER_PRO, AUTHOR_PRO, ADMIN_PRO, RESTRICTED_AUTHOR, RESTRICTED_READER."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null
}

variable "iam_arn" {
  description = "ARN of the IAM user or role that you are registering with Amazon QuickSight. Required only for users with an identity type of IAM"
  type        = string
  default     = null

  validation {
    condition     = var.iam_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:(user|role)/.+", var.iam_arn))
    error_message = "resource_aws_quicksight_user, iam_arn must be a valid IAM user or role ARN format."
  }
}

variable "namespace" {
  description = "The Amazon Quicksight namespace to create the user in. Defaults to default"
  type        = string
  default     = "default"
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "session_name" {
  description = "Name of the IAM session to use when assuming roles that can embed QuickSight dashboards. Only valid for registering users using an assumed IAM role"
  type        = string
  default     = null
}

variable "user_name" {
  description = "Amazon QuickSight user name that you want to create for the user you are registering. Required only for users with an identity type of QUICKSIGHT"
  type        = string
  default     = null
}