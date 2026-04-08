variable "name" {
  description = "The fully qualified name for the directory, such as corp.example.com"
  type        = string
}

variable "password" {
  description = "The password for the directory administrator or connector user"
  type        = string
  sensitive   = true
}

variable "size" {
  description = "The size of the directory (Small or Large are accepted values). For SimpleAD and ADConnector types"
  type        = string
  default     = "Large"

  validation {
    condition     = var.size == null || contains(["Small", "Large"], var.size)
    error_message = "resource_aws_directory_service_directory, size must be either 'Small' or 'Large'."
  }
}

variable "alias" {
  description = "The alias for the directory (must be unique amongst all aliases in AWS). Required for enable_sso"
  type        = string
  default     = null
}

variable "description" {
  description = "A textual description for the directory"
  type        = string
  default     = null
}

variable "desired_number_of_domain_controllers" {
  description = "The number of domain controllers desired in the directory. Minimum value of 2. Scaling of domain controllers is only supported for MicrosoftAD directories"
  type        = number
  default     = null

  validation {
    condition     = var.desired_number_of_domain_controllers == null || var.desired_number_of_domain_controllers >= 2
    error_message = "resource_aws_directory_service_directory, desired_number_of_domain_controllers must be at least 2."
  }
}

variable "short_name" {
  description = "The short name of the directory, such as CORP"
  type        = string
  default     = null
}

variable "enable_sso" {
  description = "Whether to enable single-sign on for the directory. Requires alias. Defaults to false"
  type        = bool
  default     = false
}

variable "type" {
  description = "The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD"
  type        = string
  default     = "SimpleAD"

  validation {
    condition     = contains(["SimpleAD", "ADConnector", "MicrosoftAD"], var.type)
    error_message = "resource_aws_directory_service_directory, type must be one of 'SimpleAD', 'ADConnector', or 'MicrosoftAD'."
  }
}

variable "edition" {
  description = "The MicrosoftAD edition (Standard or Enterprise). Defaults to Enterprise. For type MicrosoftAD only"
  type        = string
  default     = "Enterprise"

  validation {
    condition     = var.edition == null || contains(["Standard", "Enterprise"], var.edition)
    error_message = "resource_aws_directory_service_directory, edition must be either 'Standard' or 'Enterprise'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_settings" {
  description = "VPC related information about the directory. Required for SimpleAD and MicrosoftAD"
  type = object({
    subnet_ids = list(string)
    vpc_id     = string
  })
  default = null

  validation {
    condition = var.vpc_settings == null || (
      length(var.vpc_settings.subnet_ids) == 2 &&
      var.vpc_settings.vpc_id != null && var.vpc_settings.vpc_id != ""
    )
    error_message = "resource_aws_directory_service_directory, vpc_settings subnet_ids must contain exactly 2 subnets and vpc_id must be provided."
  }
}

variable "connect_settings" {
  description = "Connector related information about the directory. Required for ADConnector"
  type = object({
    customer_username = string
    customer_dns_ips  = list(string)
    subnet_ids        = list(string)
    vpc_id            = string
  })
  default = null

  validation {
    condition = var.connect_settings == null || (
      var.connect_settings.customer_username != null && var.connect_settings.customer_username != "" &&
      length(var.connect_settings.customer_dns_ips) > 0 &&
      length(var.connect_settings.subnet_ids) == 2 &&
      var.connect_settings.vpc_id != null && var.connect_settings.vpc_id != ""
    )
    error_message = "resource_aws_directory_service_directory, connect_settings requires customer_username, at least one customer_dns_ip, exactly 2 subnet_ids, and vpc_id."
  }
}

variable "timeouts" {
  description = "Timeouts configuration for the resource"
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = null
}