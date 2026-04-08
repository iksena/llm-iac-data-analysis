variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain" {
  description = "For custom domains, this is the fully-qualified domain name, such as auth.example.com. For Amazon Cognito prefix domains, this is the prefix alone, such as auth."
  type        = string

  validation {
    condition     = length(var.domain) > 0
    error_message = "resource_aws_cognito_user_pool_domain, domain cannot be empty."
  }
}

variable "user_pool_id" {
  description = "The user pool ID."
  type        = string

  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "resource_aws_cognito_user_pool_domain, user_pool_id cannot be empty."
  }
}

variable "certificate_arn" {
  description = "The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain."
  type        = string
  default     = null

  validation {
    condition     = var.certificate_arn == null || can(regex("^arn:aws:acm:", var.certificate_arn))
    error_message = "resource_aws_cognito_user_pool_domain, certificate_arn must be a valid ARN starting with 'arn:aws:acm:'."
  }
}

variable "managed_login_version" {
  description = "A version number that indicates the state of managed login for your domain. Valid values: 1 for hosted UI (classic), 2 for the newer managed login with the branding designer."
  type        = number
  default     = null

  validation {
    condition     = var.managed_login_version == null || contains([1, 2], var.managed_login_version)
    error_message = "resource_aws_cognito_user_pool_domain, managed_login_version must be either 1 or 2."
  }
}