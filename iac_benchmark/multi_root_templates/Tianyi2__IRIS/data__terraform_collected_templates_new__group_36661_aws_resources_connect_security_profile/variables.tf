variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_security_profile, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Specifies the name of the Security Profile."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 127
    error_message = "resource_aws_connect_security_profile, name must be between 1 and 127 characters."
  }
}

variable "description" {
  description = "Specifies the description of the Security Profile."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 0 && length(var.description) <= 250)
    error_message = "resource_aws_connect_security_profile, description must be between 0 and 250 characters when provided."
  }
}

variable "permissions" {
  description = "Specifies a list of permissions assigned to the security profile."
  type        = list(string)
  default     = null

  validation {
    condition     = var.permissions == null || length(var.permissions) >= 0
    error_message = "resource_aws_connect_security_profile, permissions must be a valid list of permission strings when provided."
  }
}

variable "tags" {
  description = "Tags to apply to the Security Profile."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || can(keys(var.tags))
    error_message = "resource_aws_connect_security_profile, tags must be a valid map of key-value pairs when provided."
  }
}