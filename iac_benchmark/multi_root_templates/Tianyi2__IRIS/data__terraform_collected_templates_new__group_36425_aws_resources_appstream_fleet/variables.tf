variable "name" {
  type        = string
  description = "Unique name for the fleet"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]+$", var.name))
    error_message = "resource_aws_appstream_fleet, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "instance_type" {
  type        = string
  description = "Instance type to use when launching fleet instances"

  validation {
    condition = contains([
      "stream.standard.small",
      "stream.standard.medium",
      "stream.standard.large",
      "stream.standard.xlarge",
      "stream.standard.2xlarge",
      "stream.compute.large",
      "stream.compute.xlarge",
      "stream.compute.2xlarge",
      "stream.compute.4xlarge",
      "stream.compute.8xlarge",
      "stream.memory.large",
      "stream.memory.xlarge",
      "stream.memory.2xlarge",
      "stream.memory.4xlarge",
      "stream.memory.8xlarge",
      "stream.memory.z1d.large",
      "stream.memory.z1d.xlarge",
      "stream.memory.z1d.2xlarge",
      "stream.memory.z1d.3xlarge",
      "stream.memory.z1d.6xlarge",
      "stream.memory.z1d.12xlarge",
      "stream.graphics-design.large",
      "stream.graphics-design.xlarge",
      "stream.graphics-design.2xlarge",
      "stream.graphics-design.4xlarge",
      "stream.graphics-desktop.2xlarge",
      "stream.graphics.g4dn.xlarge",
      "stream.graphics.g4dn.2xlarge",
      "stream.graphics.g4dn.4xlarge",
      "stream.graphics.g4dn.8xlarge",
      "stream.graphics.g4dn.12xlarge",
      "stream.graphics.g4dn.16xlarge",
      "stream.graphics-pro.4xlarge",
      "stream.graphics-pro.8xlarge",
      "stream.graphics-pro.16xlarge"
    ], var.instance_type)
    error_message = "resource_aws_appstream_fleet, instance_type must be a valid AppStream instance type."
  }
}

variable "compute_capacity" {
  type = object({
    desired_instances = optional(number)
    desired_sessions  = optional(number)
  })
  description = "Configuration block for the desired capacity of the fleet"

  validation {
    condition     = (var.compute_capacity.desired_instances != null && var.compute_capacity.desired_sessions == null) || (var.compute_capacity.desired_instances == null && var.compute_capacity.desired_sessions != null)
    error_message = "resource_aws_appstream_fleet, compute_capacity must have exactly one of desired_instances or desired_sessions set."
  }

  validation {
    condition     = var.compute_capacity.desired_instances == null || (var.compute_capacity.desired_instances >= 0 && var.compute_capacity.desired_instances <= 999)
    error_message = "resource_aws_appstream_fleet, compute_capacity desired_instances must be between 0 and 999."
  }

  validation {
    condition     = var.compute_capacity.desired_sessions == null || (var.compute_capacity.desired_sessions >= 1 && var.compute_capacity.desired_sessions <= 5000)
    error_message = "resource_aws_appstream_fleet, compute_capacity desired_sessions must be between 1 and 5000."
  }
}

variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed"
}

variable "description" {
  type        = string
  default     = null
  description = "Description to display"
}

variable "disconnect_timeout_in_seconds" {
  type        = number
  default     = null
  description = "Amount of time that a streaming session remains active after users disconnect"

  validation {
    condition     = var.disconnect_timeout_in_seconds == null || (var.disconnect_timeout_in_seconds >= 60 && var.disconnect_timeout_in_seconds <= 432000)
    error_message = "resource_aws_appstream_fleet, disconnect_timeout_in_seconds must be between 60 and 432000 seconds."
  }
}

variable "display_name" {
  type        = string
  default     = null
  description = "Human-readable friendly name for the AppStream fleet"
}

variable "domain_join_info" {
  type = object({
    directory_name                         = optional(string)
    organizational_unit_distinguished_name = optional(string)
  })
  default     = null
  description = "Configuration block for the name of the directory and organizational unit (OU) to use to join the fleet to a Microsoft Active Directory domain"
}

variable "enable_default_internet_access" {
  type        = bool
  default     = null
  description = "Enables or disables default internet access for the fleet"
}

variable "fleet_type" {
  type        = string
  default     = null
  description = "Fleet type"

  validation {
    condition     = var.fleet_type == null || contains(["ON_DEMAND", "ALWAYS_ON"], var.fleet_type)
    error_message = "resource_aws_appstream_fleet, fleet_type must be either ON_DEMAND or ALWAYS_ON."
  }
}

variable "iam_role_arn" {
  type        = string
  default     = null
  description = "ARN of the IAM role to apply to the fleet"

  validation {
    condition     = var.iam_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.*", var.iam_role_arn))
    error_message = "resource_aws_appstream_fleet, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "idle_disconnect_timeout_in_seconds" {
  type        = number
  default     = null
  description = "Amount of time that users can be idle (inactive) before they are disconnected from their streaming session"

  validation {
    condition     = var.idle_disconnect_timeout_in_seconds == null || (var.idle_disconnect_timeout_in_seconds >= 60 && var.idle_disconnect_timeout_in_seconds <= 3600)
    error_message = "resource_aws_appstream_fleet, idle_disconnect_timeout_in_seconds must be between 60 and 3600 seconds."
  }
}

variable "image_name" {
  type        = string
  default     = null
  description = "Name of the image used to create the fleet"
}

variable "image_arn" {
  type        = string
  default     = null
  description = "ARN of the public, private, or shared image to use"

  validation {
    condition     = var.image_arn == null || can(regex("^arn:aws:appstream:[a-z0-9-]+:[0-9]{12}:image/.*", var.image_arn))
    error_message = "resource_aws_appstream_fleet, image_arn must be a valid AppStream image ARN."
  }
}

variable "stream_view" {
  type        = string
  default     = null
  description = "AppStream 2.0 view that is displayed to your users when they stream from the fleet"

  validation {
    condition     = var.stream_view == null || contains(["APP", "DESKTOP"], var.stream_view)
    error_message = "resource_aws_appstream_fleet, stream_view must be either APP or DESKTOP."
  }
}

variable "max_sessions_per_instance" {
  type        = number
  default     = null
  description = "The maximum number of user sessions on an instance. This only applies to multi-session fleets"

  validation {
    condition     = var.max_sessions_per_instance == null || (var.max_sessions_per_instance >= 1 && var.max_sessions_per_instance <= 50)
    error_message = "resource_aws_appstream_fleet, max_sessions_per_instance must be between 1 and 50."
  }
}

variable "max_user_duration_in_seconds" {
  type        = number
  default     = null
  description = "Maximum amount of time that a streaming session can remain active, in seconds"

  validation {
    condition     = var.max_user_duration_in_seconds == null || (var.max_user_duration_in_seconds >= 600 && var.max_user_duration_in_seconds <= 432000)
    error_message = "resource_aws_appstream_fleet, max_user_duration_in_seconds must be between 600 and 432000 seconds."
  }
}

variable "vpc_config" {
  type = object({
    security_group_ids = optional(list(string))
    subnet_ids         = optional(list(string))
  })
  default     = null
  description = "Configuration block for the VPC configuration for the image builder"

  validation {
    condition = var.vpc_config == null || (
      var.vpc_config.subnet_ids != null && length(var.vpc_config.subnet_ids) > 0
    )
    error_message = "resource_aws_appstream_fleet, vpc_config subnet_ids must be provided when vpc_config is specified."
  }

  validation {
    condition = var.vpc_config == null || var.vpc_config.security_group_ids == null || (
      length(var.vpc_config.security_group_ids) > 0 && length(var.vpc_config.security_group_ids) <= 5
    )
    error_message = "resource_aws_appstream_fleet, vpc_config security_group_ids must contain between 1 and 5 security group IDs when specified."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to attach to AppStream instances"
}