variable "access_string" {
  description = "Access permissions string used for this user"
  type        = string
}

variable "engine" {
  description = "The current supported values are redis, valkey (case insensitive)"
  type        = string
  validation {
    condition     = contains(["redis", "valkey", "REDIS", "VALKEY"], var.engine)
    error_message = "resource_aws_elasticache_user, engine must be one of: redis, valkey (case insensitive)."
  }
}

variable "user_id" {
  description = "The ID of the user"
  type        = string
}

variable "user_name" {
  description = "The username of the user"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "authentication_mode" {
  description = "Denotes the user's authentication properties"
  type = object({
    type      = string
    passwords = optional(list(string))
  })
  default = null
  validation {
    condition     = var.authentication_mode == null || contains(["password", "no-password-required", "iam"], var.authentication_mode.type)
    error_message = "resource_aws_elasticache_user, authentication_mode.type must be one of: password, no-password-required, iam."
  }
  validation {
    condition = var.authentication_mode == null || (
      var.authentication_mode.type == "password" ? var.authentication_mode.passwords != null : true
    )
    error_message = "resource_aws_elasticache_user, authentication_mode.passwords is required when type is 'password'."
  }
}

variable "no_password_required" {
  description = "Indicates a password is not required for this user"
  type        = bool
  default     = null
}

variable "passwords" {
  description = "Passwords used for this user. You can create up to two passwords for each user"
  type        = list(string)
  default     = null
  validation {
    condition     = var.passwords == null || length(var.passwords) <= 2
    error_message = "resource_aws_elasticache_user, passwords can have at most 2 passwords."
  }
  sensitive = true
}

variable "tags" {
  description = "A list of tags to be added to this resource. A tag is a key-value pair"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for operation timeouts"
  type = object({
    create = optional(string, "5m")
    read   = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {}
}