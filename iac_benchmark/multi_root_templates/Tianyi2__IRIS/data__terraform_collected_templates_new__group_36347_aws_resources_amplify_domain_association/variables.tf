variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app_id" {
  description = "Unique ID for an Amplify app."
  type        = string
  validation {
    condition     = length(var.app_id) > 0
    error_message = "resource_aws_amplify_domain_association, app_id must be a non-empty string."
  }
}

variable "domain_name" {
  description = "Domain name for the domain association."
  type        = string
  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_amplify_domain_association, domain_name must be a non-empty string."
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\\.([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?))*$", var.domain_name))
    error_message = "resource_aws_amplify_domain_association, domain_name must be a valid domain name."
  }
}

variable "enable_auto_sub_domain" {
  description = "Enables the automated creation of subdomains for branches."
  type        = bool
  default     = null
}

variable "wait_for_verification" {
  description = "If enabled, the resource will wait for the domain association status to change to PENDING_DEPLOYMENT or AVAILABLE. Setting this to false will skip the process."
  type        = bool
  default     = true
}

variable "certificate_settings" {
  description = "The type of SSL/TLS certificate to use for your custom domain."
  type = object({
    type                   = string
    custom_certificate_arn = optional(string)
  })
  default = null
  validation {
    condition     = var.certificate_settings == null || contains(["AMPLIFY_MANAGED", "CUSTOM"], var.certificate_settings.type)
    error_message = "resource_aws_amplify_domain_association, certificate_settings.type must be either AMPLIFY_MANAGED or CUSTOM."
  }
  validation {
    condition     = var.certificate_settings == null || (var.certificate_settings.type != "CUSTOM" || var.certificate_settings.custom_certificate_arn != null)
    error_message = "resource_aws_amplify_domain_association, certificate_settings.custom_certificate_arn is required when type is CUSTOM."
  }
  validation {
    condition     = var.certificate_settings == null || var.certificate_settings.custom_certificate_arn == null || can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/[a-z0-9-]+$", var.certificate_settings.custom_certificate_arn))
    error_message = "resource_aws_amplify_domain_association, certificate_settings.custom_certificate_arn must be a valid ACM certificate ARN when provided."
  }
}

variable "sub_domain" {
  description = "Setting for the subdomain."
  type = list(object({
    branch_name = string
    prefix      = string
  }))
  validation {
    condition     = length(var.sub_domain) > 0
    error_message = "resource_aws_amplify_domain_association, sub_domain must contain at least one subdomain configuration."
  }
  validation {
    condition = alltrue([
      for sd in var.sub_domain : length(sd.branch_name) > 0
    ])
    error_message = "resource_aws_amplify_domain_association, sub_domain.branch_name must be a non-empty string for all subdomains."
  }
  validation {
    condition = alltrue([
      for sd in var.sub_domain : sd.prefix != null
    ])
    error_message = "resource_aws_amplify_domain_association, sub_domain.prefix must be provided for all subdomains (can be empty string)."
  }
}