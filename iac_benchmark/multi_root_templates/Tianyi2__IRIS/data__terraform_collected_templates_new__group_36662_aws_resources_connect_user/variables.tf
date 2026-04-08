variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "directory_user_id" {
  description = "The identifier of the user account in the directory used for identity management"
  type        = string
  default     = null
}

variable "hierarchy_group_id" {
  description = "The identifier of the hierarchy group for the user"
  type        = string
  default     = null
}

variable "identity_info" {
  description = "A block that contains information about the identity of the user"
  type = object({
    email           = optional(string)
    first_name      = optional(string)
    last_name       = optional(string)
    secondary_email = optional(string)
  })
  default = null

  validation {
    condition = var.identity_info == null ? true : (
      var.identity_info.first_name == null ? true : (
        length(var.identity_info.first_name) >= 1 && length(var.identity_info.first_name) <= 100
      )
    )
    error_message = "resource_aws_connect_user, first_name must be between 1 and 100 characters in length."
  }

  validation {
    condition = var.identity_info == null ? true : (
      var.identity_info.last_name == null ? true : (
        length(var.identity_info.last_name) >= 1 && length(var.identity_info.last_name) <= 100
      )
    )
    error_message = "resource_aws_connect_user, last_name must be between 1 and 100 characters in length."
  }
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "resource_aws_connect_user, instance_id is required and cannot be empty."
  }
}

variable "name" {
  description = "The user name for the account"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_connect_user, name must be between 1 and 64 characters in length."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\.@]+$", var.name))
    error_message = "resource_aws_connect_user, name can only contain characters [a-zA-Z0-9_-.@]."
  }
}

variable "password" {
  description = "The password for the user account"
  type        = string
  default     = null
  sensitive   = true
}

variable "phone_config" {
  description = "A block that contains information about the phone settings for the user"
  type = object({
    after_contact_work_time_limit = optional(number)
    auto_accept                   = optional(bool)
    desk_phone_number             = optional(string)
    phone_type                    = string
  })

  validation {
    condition     = contains(["DESK_PHONE", "SOFT_PHONE"], var.phone_config.phone_type)
    error_message = "resource_aws_connect_user, phone_type must be either 'DESK_PHONE' or 'SOFT_PHONE'."
  }

  validation {
    condition = var.phone_config.after_contact_work_time_limit == null ? true : (
      var.phone_config.after_contact_work_time_limit >= 0
    )
    error_message = "resource_aws_connect_user, after_contact_work_time_limit must be greater than or equal to 0."
  }

  validation {
    condition = var.phone_config.phone_type == "DESK_PHONE" ? (
      var.phone_config.desk_phone_number != null && length(var.phone_config.desk_phone_number) > 0
    ) : true
    error_message = "resource_aws_connect_user, desk_phone_number is required when phone_type is 'DESK_PHONE'."
  }
}

variable "routing_profile_id" {
  description = "The identifier of the routing profile for the user"
  type        = string

  validation {
    condition     = length(var.routing_profile_id) > 0
    error_message = "resource_aws_connect_user, routing_profile_id is required and cannot be empty."
  }
}

variable "security_profile_ids" {
  description = "A list of identifiers for the security profiles for the user"
  type        = list(string)

  validation {
    condition     = length(var.security_profile_ids) >= 1 && length(var.security_profile_ids) <= 10
    error_message = "resource_aws_connect_user, security_profile_ids must specify a minimum of 1 and maximum of 10 security profile ids."
  }

  validation {
    condition = alltrue([
      for id in var.security_profile_ids : length(id) > 0
    ])
    error_message = "resource_aws_connect_user, security_profile_ids cannot contain empty strings."
  }
}

variable "tags" {
  description = "Tags to apply to the user"
  type        = map(string)
  default     = {}
}