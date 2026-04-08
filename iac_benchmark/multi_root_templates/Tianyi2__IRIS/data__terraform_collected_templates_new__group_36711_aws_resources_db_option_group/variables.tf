variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the option group. If omitted, Terraform will assign a random, unique name. Must be lowercase, to match as it is stored in AWS."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-z0-9-]+$", var.name))
    error_message = "resource_aws_db_option_group, name must be lowercase and contain only alphanumeric characters and hyphens."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Must be lowercase, to match as it is stored in AWS."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "resource_aws_db_option_group, name_prefix must be lowercase and contain only alphanumeric characters and hyphens."
  }
}

variable "option_group_description" {
  description = "Description of the option group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with."
  type        = string

  validation {
    condition     = contains(["mariadb", "mysql", "oracle-ee", "oracle-ee-cdb", "oracle-se2", "oracle-se2-cdb", "postgres", "sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"], var.engine_name)
    error_message = "resource_aws_db_option_group, engine_name must be a valid RDS engine name."
  }
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.major_engine_version))
    error_message = "resource_aws_db_option_group, major_engine_version must be in the format 'X.Y' (e.g., '11.00', '8.0')."
  }
}

variable "option" {
  description = "The options to apply."
  type = list(object({
    option_name                    = string
    port                           = optional(number)
    version                        = optional(string)
    db_security_group_memberships  = optional(list(string))
    vpc_security_group_memberships = optional(list(string))
    option_settings = optional(list(object({
      name  = string
      value = string
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for opt in var.option : opt.option_name != null && opt.option_name != ""
    ])
    error_message = "resource_aws_db_option_group, option option_name must be specified and non-empty."
  }

  validation {
    condition = alltrue([
      for opt in var.option : opt.port == null || (opt.port >= 1 && opt.port <= 65535)
    ])
    error_message = "resource_aws_db_option_group, option port must be between 1 and 65535 when specified."
  }

  validation {
    condition = alltrue([
      for opt in var.option : opt.option_settings == null || alltrue([
        for setting in opt.option_settings : setting.name != null && setting.name != "" && setting.value != null && setting.value != ""
      ])
    ])
    error_message = "resource_aws_db_option_group, option option_settings name and value must be specified and non-empty when option_settings is provided."
  }
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the option group to be deleted at destroy time, and instead just remove the option group from the Terraform state."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_db_option_group, timeouts_delete must be a valid timeout format (e.g., '15m', '1h', '30s')."
  }
}