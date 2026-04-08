variable "access_string" {
  description = "Access permissions string used for this user"
  type        = string

  validation {
    condition     = length(var.access_string) > 0
    error_message = "resource_aws_memorydb_user, access_string must not be empty."
  }
}

variable "authentication_mode" {
  description = "Denotes the user's authentication properties"
  type = object({
    type      = string
    passwords = optional(set(string), [])
  })

  validation {
    condition     = contains(["password", "iam"], var.authentication_mode.type)
    error_message = "resource_aws_memorydb_user, authentication_mode.type must be 'password' or 'iam'."
  }

  validation {
    condition     = var.authentication_mode.type == "password" ? length(var.authentication_mode.passwords) <= 2 : true
    error_message = "resource_aws_memorydb_user, authentication_mode.passwords can have up to 2 passwords when type is 'password'."
  }

  validation {
    condition     = var.authentication_mode.type == "password" ? length(var.authentication_mode.passwords) > 0 : true
    error_message = "resource_aws_memorydb_user, authentication_mode.passwords must be provided when type is 'password'."
  }
}

variable "user_name" {
  description = "Name of the MemoryDB user. Up to 40 characters"
  type        = string

  validation {
    condition     = length(var.user_name) > 0 && length(var.user_name) <= 40
    error_message = "resource_aws_memorydb_user, user_name must be between 1 and 40 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}