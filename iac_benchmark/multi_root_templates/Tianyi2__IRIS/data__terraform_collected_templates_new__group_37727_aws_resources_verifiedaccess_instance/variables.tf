variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_verifiedaccess_instance, region must be a valid AWS region format."
  }
}

variable "description" {
  description = "A description for the AWS Verified Access Instance."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) > 0
    error_message = "resource_aws_verifiedaccess_instance, description must not be empty if provided."
  }
}

variable "fips_enabled" {
  description = "Enable or disable support for Federal Information Processing Standards (FIPS) on the AWS Verified Access Instance. Forces new resource."
  type        = bool
  default     = null

  validation {
    condition     = var.fips_enabled == null || can(tobool(var.fips_enabled))
    error_message = "resource_aws_verifiedaccess_instance, fips_enabled must be a boolean value."
  }
}

variable "cidr_endpoints_custom_subdomain" {
  description = "The custom subdomain for the CIDR endpoints."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_endpoints_custom_subdomain == null || can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.cidr_endpoints_custom_subdomain))
    error_message = "resource_aws_verifiedaccess_instance, cidr_endpoints_custom_subdomain must be a valid domain format."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) >= 0])
    error_message = "resource_aws_verifiedaccess_instance, tags keys must not be empty."
  }
}