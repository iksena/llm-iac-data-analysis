variable "account_name" {
  description = "Name of your Amazon QuickSight account. This name is unique over all of AWS, and it appears only when users sign in."
  type        = string

  validation {
    condition     = length(var.account_name) > 0
    error_message = "resource_aws_quicksight_account_subscription, account_name cannot be empty."
  }
}

variable "authentication_method" {
  description = "Method that you want to use to authenticate your Amazon QuickSight account. Currently, the valid values for this parameter are IAM_AND_QUICKSIGHT, IAM_ONLY, IAM_IDENTITY_CENTER, and ACTIVE_DIRECTORY."
  type        = string

  validation {
    condition     = contains(["IAM_AND_QUICKSIGHT", "IAM_ONLY", "IAM_IDENTITY_CENTER", "ACTIVE_DIRECTORY"], var.authentication_method)
    error_message = "resource_aws_quicksight_account_subscription, authentication_method must be one of: IAM_AND_QUICKSIGHT, IAM_ONLY, IAM_IDENTITY_CENTER, ACTIVE_DIRECTORY."
  }
}

variable "edition" {
  description = "Edition of Amazon QuickSight that you want your account to have. Currently, you can choose from STANDARD, ENTERPRISE or ENTERPRISE_AND_Q."
  type        = string

  validation {
    condition     = contains(["STANDARD", "ENTERPRISE", "ENTERPRISE_AND_Q"], var.edition)
    error_message = "resource_aws_quicksight_account_subscription, edition must be one of: STANDARD, ENTERPRISE, ENTERPRISE_AND_Q."
  }
}

variable "notification_email" {
  description = "Email address that you want Amazon QuickSight to send notifications to regarding your Amazon QuickSight account or Amazon QuickSight subscription."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.notification_email))
    error_message = "resource_aws_quicksight_account_subscription, notification_email must be a valid email address."
  }
}

variable "active_directory_name" {
  description = "Name of your Active Directory. This field is required if ACTIVE_DIRECTORY is the selected authentication method of the new Amazon QuickSight account."
  type        = string
  default     = null

  validation {
    condition     = var.authentication_method != "ACTIVE_DIRECTORY" || var.active_directory_name != null
    error_message = "resource_aws_quicksight_account_subscription, active_directory_name is required when authentication_method is ACTIVE_DIRECTORY."
  }
}

variable "admin_group" {
  description = "Admin group associated with your Active Directory or IAM Identity Center account. This field is required if ACTIVE_DIRECTORY or IAM_IDENTITY_CENTER is the selected authentication method of the new Amazon QuickSight account."
  type        = list(string)
  default     = null

  validation {
    condition     = !contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) || var.admin_group != null
    error_message = "resource_aws_quicksight_account_subscription, admin_group is required when authentication_method is ACTIVE_DIRECTORY or IAM_IDENTITY_CENTER."
  }
}

variable "author_group" {
  description = "Author group associated with your Active Directory or IAM Identity Center account."
  type        = list(string)
  default     = null
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^\\d{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_account_subscription, aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "contact_number" {
  description = "A 10-digit phone number for the author of the Amazon QuickSight account to use for future communications. This field is required if ENTERPRISE_AND_Q is the selected edition of the new Amazon QuickSight account."
  type        = string
  default     = null

  validation {
    condition     = var.edition != "ENTERPRISE_AND_Q" || var.contact_number != null
    error_message = "resource_aws_quicksight_account_subscription, contact_number is required when edition is ENTERPRISE_AND_Q."
  }

  validation {
    condition     = var.contact_number == null || can(regex("^\\d{10}$", var.contact_number))
    error_message = "resource_aws_quicksight_account_subscription, contact_number must be a 10-digit phone number."
  }
}

variable "directory_id" {
  description = "Active Directory ID that is associated with your Amazon QuickSight account."
  type        = string
  default     = null
}

variable "email_address" {
  description = "Email address of the author of the Amazon QuickSight account to use for future communications. This field is required if ENTERPRISE_AND_Q is the selected edition of the new Amazon QuickSight account."
  type        = string
  default     = null

  validation {
    condition     = var.edition != "ENTERPRISE_AND_Q" || var.email_address != null
    error_message = "resource_aws_quicksight_account_subscription, email_address is required when edition is ENTERPRISE_AND_Q."
  }

  validation {
    condition     = var.email_address == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "resource_aws_quicksight_account_subscription, email_address must be a valid email address."
  }
}

variable "first_name" {
  description = "First name of the author of the Amazon QuickSight account to use for future communications. This field is required if ENTERPRISE_AND_Q is the selected edition of the new Amazon QuickSight account."
  type        = string
  default     = null

  validation {
    condition     = var.edition != "ENTERPRISE_AND_Q" || var.first_name != null
    error_message = "resource_aws_quicksight_account_subscription, first_name is required when edition is ENTERPRISE_AND_Q."
  }
}

variable "iam_identity_center_instance_arn" {
  description = "The Amazon Resource Name (ARN) for the IAM Identity Center instance."
  type        = string
  default     = null

  validation {
    condition     = var.iam_identity_center_instance_arn == null || can(regex("^arn:aws:sso:::instance/[a-zA-Z0-9-]+$", var.iam_identity_center_instance_arn))
    error_message = "resource_aws_quicksight_account_subscription, iam_identity_center_instance_arn must be a valid IAM Identity Center instance ARN."
  }
}

variable "last_name" {
  description = "Last name of the author of the Amazon QuickSight account to use for future communications. This field is required if ENTERPRISE_AND_Q is the selected edition of the new Amazon QuickSight account."
  type        = string
  default     = null

  validation {
    condition     = var.edition != "ENTERPRISE_AND_Q" || var.last_name != null
    error_message = "resource_aws_quicksight_account_subscription, last_name is required when edition is ENTERPRISE_AND_Q."
  }
}

variable "reader_group" {
  description = "Reader group associated with your Active Directory or IAM Identity Center account."
  type        = list(string)
  default     = null
}

variable "realm" {
  description = "Realm of the Active Directory that is associated with your Amazon QuickSight account."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Create timeout"
  type        = string
  default     = "10m"
}

variable "timeouts_delete" {
  description = "Delete timeout"
  type        = string
  default     = "10m"
}