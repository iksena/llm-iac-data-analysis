variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Custom domain endpoint to association. Specify a base domain e.g., example.com or a subdomain e.g., subdomain.example.com."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_apprunner_custom_domain_association, domain_name must be a non-empty string."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*$", var.domain_name))
    error_message = "resource_aws_apprunner_custom_domain_association, domain_name must be a valid domain name."
  }
}

variable "enable_www_subdomain" {
  description = "Whether to associate the subdomain with the App Runner service in addition to the base domain. Defaults to true."
  type        = bool
  default     = true
}

variable "service_arn" {
  description = "ARN of the App Runner service."
  type        = string

  validation {
    condition     = length(var.service_arn) > 0
    error_message = "resource_aws_apprunner_custom_domain_association, service_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws:apprunner:[a-z0-9\\-]+:[0-9]{12}:service/[a-zA-Z0-9\\-_]+/[a-zA-Z0-9]+$", var.service_arn))
    error_message = "resource_aws_apprunner_custom_domain_association, service_arn must be a valid App Runner service ARN."
  }
}