variable "name" {
  description = "Name of the service. The name must be unique within the account. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen. Must be between 3 and 40 characters in length."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.name)) && length(var.name) >= 3 && length(var.name) <= 40 && !can(regex("--", var.name))
    error_message = "resource_aws_vpclattice_service, name: The name must be unique within the account. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen. Must be between 3 and 40 characters in length."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auth_type" {
  description = "Type of IAM policy. Either NONE or AWS_IAM."
  type        = string
  default     = null

  validation {
    condition     = var.auth_type == null || contains(["NONE", "AWS_IAM"], var.auth_type)
    error_message = "resource_aws_vpclattice_service, auth_type: Type of IAM policy. Either NONE or AWS_IAM."
  }
}

variable "certificate_arn" {
  description = "Amazon Resource Name (ARN) of the certificate."
  type        = string
  default     = null

  validation {
    condition     = var.certificate_arn == null || can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/[a-z0-9-]+$", var.certificate_arn))
    error_message = "resource_aws_vpclattice_service, certificate_arn: Amazon Resource Name (ARN) of the certificate must be a valid ACM certificate ARN."
  }
}

variable "custom_domain_name" {
  description = "Custom domain name of the service."
  type        = string
  default     = null

  validation {
    condition     = var.custom_domain_name == null || can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.custom_domain_name))
    error_message = "resource_aws_vpclattice_service, custom_domain_name: Custom domain name must be a valid domain name format."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = null
}