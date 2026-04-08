variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "data_aws_connect_security_profile, instance_id must not be empty."
  }
}

variable "security_profile_id" {
  description = "Returns information on a specific Security Profile by Security Profile id"
  type        = string
  default     = null

  validation {
    condition     = var.security_profile_id == null || length(var.security_profile_id) > 0
    error_message = "data_aws_connect_security_profile, security_profile_id must not be empty when provided."
  }
}

variable "name" {
  description = "Returns information on a specific Security Profile by name"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_connect_security_profile, name must not be empty when provided."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_connect_security_profile, region must not be empty when provided."
  }
}