variable "application_provider_arn" {
  description = "ARN of the application provider"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso::", var.application_provider_arn))
    error_message = "resource_aws_ssoadmin_application, application_provider_arn must be a valid SSO application provider ARN."
  }
}

variable "instance_arn" {
  description = "ARN of the instance of IAM Identity Center"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/", var.instance_arn))
    error_message = "resource_aws_ssoadmin_application, instance_arn must be a valid SSO instance ARN."
  }
}

variable "name" {
  description = "Name of the application"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "resource_aws_ssoadmin_application, name must be between 1 and 255 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "client_token" {
  description = "A unique, case-sensitive ID that you provide to ensure the idempotency of the request"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the application"
  type        = string
  default     = null
}

variable "status" {
  description = "Status of the application"
  type        = string
  default     = null

  validation {
    condition     = var.status == null || contains(["ENABLED", "DISABLED"], var.status)
    error_message = "resource_aws_ssoadmin_application, status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = null
}

variable "portal_options" {
  description = "Options for the portal associated with an application"
  type = object({
    visibility = optional(string)
    sign_in_options = optional(object({
      application_url = optional(string)
      origin          = string
    }))
  })
  default = null

  validation {
    condition     = var.portal_options == null || var.portal_options.visibility == null || contains(["ENABLED", "DISABLED"], var.portal_options.visibility)
    error_message = "resource_aws_ssoadmin_application, portal_options.visibility must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.portal_options == null || var.portal_options.sign_in_options == null || contains(["APPLICATION", "IDENTITY_CENTER"], var.portal_options.sign_in_options.origin)
    error_message = "resource_aws_ssoadmin_application, portal_options.sign_in_options.origin must be either 'APPLICATION' or 'IDENTITY_CENTER'."
  }

  validation {
    condition     = var.portal_options == null || var.portal_options.sign_in_options == null || var.portal_options.sign_in_options.application_url == null || can(regex("^https?://", var.portal_options.sign_in_options.application_url))
    error_message = "resource_aws_ssoadmin_application, portal_options.sign_in_options.application_url must be a valid URL starting with http:// or https://."
  }
}