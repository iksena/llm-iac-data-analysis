variable "name" {
  description = "The name of the target group. The name must be unique within the account. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.name)) && !can(regex("--", var.name))
    error_message = "resource_aws_vpclattice_target_group, name must contain only a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen."
  }
}

variable "type" {
  description = "The type of target group."
  type        = string

  validation {
    condition     = contains(["IP", "LAMBDA", "INSTANCE", "ALB"], var.type)
    error_message = "resource_aws_vpclattice_target_group, type must be one of: IP, LAMBDA, INSTANCE, ALB."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}

variable "config" {
  description = "The target group configuration."
  type = object({
    health_check = optional(object({
      enabled                       = optional(bool, true)
      health_check_interval_seconds = optional(number, 30)
      health_check_timeout_seconds  = optional(number, 5)
      healthy_threshold_count       = optional(number, 5)
      matcher = optional(object({
        value = optional(string)
      }))
      path                      = optional(string, "/")
      port                      = optional(number)
      protocol                  = optional(string)
      protocol_version          = optional(string, "HTTP1")
      unhealthy_threshold_count = optional(number, 2)
    }))
    ip_address_type                = optional(string)
    lambda_event_structure_version = optional(string)
    port                           = optional(number)
    protocol                       = optional(string)
    protocol_version               = optional(string, "HTTP1")
    vpc_identifier                 = optional(string)
  })
  default = null

  validation {
    condition     = var.config == null || var.config.ip_address_type == null || contains(["IPV4", "IPV6"], var.config.ip_address_type)
    error_message = "resource_aws_vpclattice_target_group, ip_address_type must be one of: IPV4, IPV6."
  }

  validation {
    condition     = var.config == null || var.config.lambda_event_structure_version == null || contains(["V1", "V2"], var.config.lambda_event_structure_version)
    error_message = "resource_aws_vpclattice_target_group, lambda_event_structure_version must be one of: V1, V2."
  }

  validation {
    condition     = var.config == null || var.config.protocol == null || contains(["HTTP", "HTTPS"], var.config.protocol)
    error_message = "resource_aws_vpclattice_target_group, protocol must be one of: HTTP, HTTPS."
  }

  validation {
    condition     = var.config == null || var.config.protocol_version == null || contains(["HTTP1", "HTTP2", "GRPC"], var.config.protocol_version)
    error_message = "resource_aws_vpclattice_target_group, protocol_version must be one of: HTTP1, HTTP2, GRPC."
  }

  validation {
    condition     = var.config == null || var.config.health_check == null || var.config.health_check.health_check_interval_seconds == null || (var.config.health_check.health_check_interval_seconds >= 5 && var.config.health_check.health_check_interval_seconds <= 300)
    error_message = "resource_aws_vpclattice_target_group, health_check_interval_seconds must be between 5 and 300 seconds."
  }

  validation {
    condition     = var.config == null || var.config.health_check == null || var.config.health_check.health_check_timeout_seconds == null || (var.config.health_check.health_check_timeout_seconds >= 1 && var.config.health_check.health_check_timeout_seconds <= 120)
    error_message = "resource_aws_vpclattice_target_group, health_check_timeout_seconds must be between 1 and 120 seconds."
  }

  validation {
    condition     = var.config == null || var.config.health_check == null || var.config.health_check.healthy_threshold_count == null || (var.config.health_check.healthy_threshold_count >= 2 && var.config.health_check.healthy_threshold_count <= 10)
    error_message = "resource_aws_vpclattice_target_group, healthy_threshold_count must be between 2 and 10."
  }

  validation {
    condition     = var.config == null || var.config.health_check == null || var.config.health_check.unhealthy_threshold_count == null || (var.config.health_check.unhealthy_threshold_count >= 2 && var.config.health_check.unhealthy_threshold_count <= 10)
    error_message = "resource_aws_vpclattice_target_group, unhealthy_threshold_count must be between 2 and 10."
  }

  validation {
    condition     = var.config == null || var.config.health_check == null || var.config.health_check.protocol == null || contains(["HTTP", "HTTPS"], var.config.health_check.protocol)
    error_message = "resource_aws_vpclattice_target_group, health_check protocol must be one of: HTTP, HTTPS."
  }

  validation {
    condition     = var.config == null || var.config.health_check == null || var.config.health_check.protocol_version == null || contains(["HTTP1", "HTTP2"], var.config.health_check.protocol_version)
    error_message = "resource_aws_vpclattice_target_group, health_check protocol_version must be one of: HTTP1, HTTP2."
  }
}

variable "timeouts" {
  description = "Configuration for resource timeouts."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    delete = "5m"
  }
}