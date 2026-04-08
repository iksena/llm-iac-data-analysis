variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "extension_arn" {
  description = "The ARN of the extension defined in the association."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:appconfig:[a-z0-9-]+:[0-9]{12}:extension/[a-zA-Z0-9]{7}$", var.extension_arn))
    error_message = "resource_aws_appconfig_extension_association, extension_arn must be a valid AppConfig extension ARN."
  }
}

variable "resource_arn" {
  description = "The ARN of the application, configuration profile, or environment to associate with the extension."
  type        = string
  default     = null

  validation {
    condition     = var.resource_arn == null || can(regex("^arn:aws[a-zA-Z-]*:appconfig:[a-z0-9-]+:[0-9]{12}:(application|configurationprofile|environment)/[a-zA-Z0-9]+", var.resource_arn))
    error_message = "resource_aws_appconfig_extension_association, resource_arn must be a valid AppConfig application, configuration profile, or environment ARN."
  }
}

variable "parameters" {
  description = "The parameter names and values defined for the association."
  type        = map(string)
  default     = null

  validation {
    condition     = var.parameters == null || length(var.parameters) >= 0
    error_message = "resource_aws_appconfig_extension_association, parameters must be a valid map of strings."
  }
}