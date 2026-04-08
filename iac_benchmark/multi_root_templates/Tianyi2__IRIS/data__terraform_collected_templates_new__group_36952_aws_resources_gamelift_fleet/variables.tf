variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "build_id" {
  description = "ID of the GameLift Build to be deployed on the fleet. Conflicts with script_id."
  type        = string
  default     = null

  validation {
    condition     = var.build_id == null || var.script_id == null
    error_message = "resource_aws_gamelift_fleet, build_id conflicts with script_id. Only one can be specified."
  }
}

variable "certificate_configuration" {
  description = "Prompts GameLift to generate a TLS/SSL certificate for the fleet."
  type = object({
    certificate_type = optional(string, "DISABLED")
  })
  default = null

  validation {
    condition = var.certificate_configuration == null || (
      var.certificate_configuration.certificate_type == null ||
      contains(["DISABLED", "GENERATED"], var.certificate_configuration.certificate_type)
    )
    error_message = "resource_aws_gamelift_fleet, certificate_configuration.certificate_type must be either 'DISABLED' or 'GENERATED'."
  }
}

variable "description" {
  description = "Human-readable description of the fleet."
  type        = string
  default     = null
}

variable "ec2_inbound_permission" {
  description = "Range of IP addresses and port settings that permit inbound traffic to access server processes running on the fleet."
  type = list(object({
    from_port = number
    ip_range  = string
    protocol  = string
    to_port   = number
  }))
  default = []

  validation {
    condition = alltrue([
      for permission in var.ec2_inbound_permission :
      permission.from_port >= 1 && permission.from_port <= 65535
    ])
    error_message = "resource_aws_gamelift_fleet, ec2_inbound_permission.from_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for permission in var.ec2_inbound_permission :
      permission.to_port >= 1 && permission.to_port <= 65535
    ])
    error_message = "resource_aws_gamelift_fleet, ec2_inbound_permission.to_port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for permission in var.ec2_inbound_permission :
      permission.to_port >= permission.from_port
    ])
    error_message = "resource_aws_gamelift_fleet, ec2_inbound_permission.to_port must be higher than from_port."
  }

  validation {
    condition = alltrue([
      for permission in var.ec2_inbound_permission :
      contains(["TCP", "UDP"], upper(permission.protocol))
    ])
    error_message = "resource_aws_gamelift_fleet, ec2_inbound_permission.protocol must be either 'TCP' or 'UDP'."
  }
}

variable "ec2_instance_type" {
  description = "Name of an EC2 instance type. E.g., t2.micro"
  type        = string

  validation {
    condition     = var.ec2_instance_type != null && var.ec2_instance_type != ""
    error_message = "resource_aws_gamelift_fleet, ec2_instance_type is required and cannot be empty."
  }
}

variable "fleet_type" {
  description = "Type of fleet. This value must be ON_DEMAND or SPOT. Defaults to ON_DEMAND."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.fleet_type)
    error_message = "resource_aws_gamelift_fleet, fleet_type must be either 'ON_DEMAND' or 'SPOT'."
  }
}

variable "instance_role_arn" {
  description = "ARN of an IAM role that instances in the fleet can assume."
  type        = string
  default     = null

  validation {
    condition     = var.instance_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/", var.instance_role_arn))
    error_message = "resource_aws_gamelift_fleet, instance_role_arn must be a valid IAM role ARN."
  }
}

variable "metric_groups" {
  description = "List of names of metric groups to add this fleet to. A metric group tracks metrics across all fleets in the group. Defaults to default."
  type        = list(string)
  default     = ["default"]

  validation {
    condition     = length(var.metric_groups) > 0
    error_message = "resource_aws_gamelift_fleet, metric_groups must contain at least one metric group."
  }
}

variable "name" {
  description = "The name of the fleet."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_gamelift_fleet, name is required and cannot be empty."
  }
}

variable "new_game_session_protection_policy" {
  description = "Game session protection policy to apply to all instances in this fleet. E.g., FullProtection. Defaults to NoProtection."
  type        = string
  default     = "NoProtection"

  validation {
    condition     = contains(["NoProtection", "FullProtection"], var.new_game_session_protection_policy)
    error_message = "resource_aws_gamelift_fleet, new_game_session_protection_policy must be either 'NoProtection' or 'FullProtection'."
  }
}

variable "resource_creation_limit_policy" {
  description = "Policy that limits the number of game sessions an individual player can create over a span of time for this fleet."
  type = object({
    new_game_sessions_per_creator = optional(number)
    policy_period_in_minutes      = optional(number)
  })
  default = null

  validation {
    condition = var.resource_creation_limit_policy == null || (
      var.resource_creation_limit_policy.new_game_sessions_per_creator == null ||
      var.resource_creation_limit_policy.new_game_sessions_per_creator > 0
    )
    error_message = "resource_aws_gamelift_fleet, resource_creation_limit_policy.new_game_sessions_per_creator must be greater than 0."
  }

  validation {
    condition = var.resource_creation_limit_policy == null || (
      var.resource_creation_limit_policy.policy_period_in_minutes == null ||
      var.resource_creation_limit_policy.policy_period_in_minutes > 0
    )
    error_message = "resource_aws_gamelift_fleet, resource_creation_limit_policy.policy_period_in_minutes must be greater than 0."
  }
}

variable "runtime_configuration" {
  description = "Instructions for launching server processes on each instance in the fleet."
  type = object({
    game_session_activation_timeout_seconds = optional(number)
    max_concurrent_game_session_activations = optional(number)
    server_process = optional(list(object({
      concurrent_executions = number
      launch_path           = string
      parameters            = optional(string)
    })))
  })
  default = null

  validation {
    condition = var.runtime_configuration == null || (
      var.runtime_configuration.game_session_activation_timeout_seconds == null ||
      var.runtime_configuration.game_session_activation_timeout_seconds > 0
    )
    error_message = "resource_aws_gamelift_fleet, runtime_configuration.game_session_activation_timeout_seconds must be greater than 0."
  }

  validation {
    condition = var.runtime_configuration == null || (
      var.runtime_configuration.max_concurrent_game_session_activations == null ||
      var.runtime_configuration.max_concurrent_game_session_activations > 0
    )
    error_message = "resource_aws_gamelift_fleet, runtime_configuration.max_concurrent_game_session_activations must be greater than 0."
  }

  validation {
    condition = var.runtime_configuration == null || var.runtime_configuration.server_process == null || alltrue([
      for process in var.runtime_configuration.server_process :
      process.concurrent_executions > 0
    ])
    error_message = "resource_aws_gamelift_fleet, runtime_configuration.server_process.concurrent_executions must be greater than 0."
  }

  validation {
    condition = var.runtime_configuration == null || var.runtime_configuration.server_process == null || alltrue([
      for process in var.runtime_configuration.server_process :
      process.launch_path != null && process.launch_path != ""
    ])
    error_message = "resource_aws_gamelift_fleet, runtime_configuration.server_process.launch_path is required and cannot be empty."
  }
}

variable "script_id" {
  description = "ID of the GameLift Script to be deployed on the fleet. Conflicts with build_id."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "70m")
    delete = optional(string, "20m")
  })
  default = {
    create = "70m"
    delete = "20m"
  }
}