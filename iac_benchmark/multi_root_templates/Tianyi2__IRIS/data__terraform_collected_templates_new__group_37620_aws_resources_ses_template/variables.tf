variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the template. Cannot exceed 64 characters. You will refer to this name when you send email."
  type        = string

  validation {
    condition     = can(regex("^.{1,64}$", var.name))
    error_message = "resource_aws_ses_template, name must not exceed 64 characters."
  }
}

variable "html" {
  description = "The HTML body of the email. Must be less than 500KB in size, including both the text and HTML parts."
  type        = string
  default     = null

  validation {
    condition     = var.html == null || length(var.html) < 512000
    error_message = "resource_aws_ses_template, html must be less than 500KB in size."
  }
}

variable "subject" {
  description = "The subject line of the email."
  type        = string
  default     = null
}

variable "text" {
  description = "The email body that will be visible to recipients whose email clients do not display HTML. Must be less than 500KB in size, including both the text and HTML parts."
  type        = string
  default     = null

  validation {
    condition     = var.text == null || length(var.text) < 512000
    error_message = "resource_aws_ses_template, text must be less than 500KB in size."
  }
}