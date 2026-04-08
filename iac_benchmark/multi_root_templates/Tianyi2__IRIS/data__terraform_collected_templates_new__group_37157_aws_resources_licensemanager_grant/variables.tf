variable "name" {
  description = "The Name of the grant"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_licensemanager_grant, name must not be empty."
  }
}

variable "allowed_operations" {
  description = "A list of the allowed operations for the grant. This is a subset of the allowed operations on the license"
  type        = list(string)

  validation {
    condition     = length(var.allowed_operations) > 0
    error_message = "resource_aws_licensemanager_grant, allowed_operations must not be empty."
  }

  validation {
    condition = alltrue([
      for op in var.allowed_operations : contains([
        "ListPurchasedLicenses",
        "CheckoutLicense",
        "CheckInLicense",
        "ExtendConsumptionLicense",
        "CreateToken"
      ], op)
    ])
    error_message = "resource_aws_licensemanager_grant, allowed_operations must contain only valid operations: ListPurchasedLicenses, CheckoutLicense, CheckInLicense, ExtendConsumptionLicense, CreateToken."
  }
}

variable "license_arn" {
  description = "The ARN of the license to grant"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:license-manager:", var.license_arn))
    error_message = "resource_aws_licensemanager_grant, license_arn must be a valid License Manager ARN starting with 'arn:aws:license-manager:'."
  }
}

variable "principal" {
  description = "The target account for the grant in the form of the ARN for an account principal of the root user"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.principal))
    error_message = "resource_aws_licensemanager_grant, principal must be a valid IAM ARN starting with 'arn:aws:iam::'."
  }
}

variable "home_region" {
  description = "The home region for the license"
  type        = string

  validation {
    condition     = length(var.home_region) > 0
    error_message = "resource_aws_licensemanager_grant, home_region must not be empty."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.home_region))
    error_message = "resource_aws_licensemanager_grant, home_region must be a valid AWS region format."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_licensemanager_grant, region must be a valid AWS region format or null."
  }
}