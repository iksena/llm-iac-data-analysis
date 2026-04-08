variable "game_server_group_name" {
  description = "Name of the game server group. This value is used to generate unique ARN identifiers for the EC2 Auto Scaling group and the GameLift FleetIQ game server group."
  type        = string

  validation {
    condition     = length(var.game_server_group_name) > 0
    error_message = "resource_aws_gamelift_game_server_group, game_server_group_name must not be empty."
  }
}

variable "max_size" {
  description = "The maximum number of instances allowed in the EC2 Auto Scaling group. During automatic scaling events, GameLift FleetIQ and EC2 do not scale up the group above this maximum."
  type        = number

  validation {
    condition     = var.max_size >= 0
    error_message = "resource_aws_gamelift_game_server_group, max_size must be a non-negative number."
  }
}

variable "min_size" {
  description = "The minimum number of instances allowed in the EC2 Auto Scaling group. During automatic scaling events, GameLift FleetIQ and EC2 do not scale down the group below this minimum."
  type        = number

  validation {
    condition     = var.min_size >= 0
    error_message = "resource_aws_gamelift_game_server_group, min_size must be a non-negative number."
  }

  validation {
    condition     = var.min_size <= var.max_size
    error_message = "resource_aws_gamelift_game_server_group, min_size must be less than or equal to max_size."
  }
}

variable "role_arn" {
  description = "ARN for an IAM role that allows Amazon GameLift to access your EC2 Auto Scaling groups."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_gamelift_game_server_group, role_arn must be a valid IAM role ARN."
  }
}

variable "balancing_strategy" {
  description = "Indicates how GameLift FleetIQ balances the use of Spot Instances and On-Demand Instances. Valid values: SPOT_ONLY, SPOT_PREFERRED, ON_DEMAND_ONLY. Defaults to SPOT_PREFERRED."
  type        = string
  default     = "SPOT_PREFERRED"

  validation {
    condition     = contains(["SPOT_ONLY", "SPOT_PREFERRED", "ON_DEMAND_ONLY"], var.balancing_strategy)
    error_message = "resource_aws_gamelift_game_server_group, balancing_strategy must be one of: SPOT_ONLY, SPOT_PREFERRED, ON_DEMAND_ONLY."
  }
}

variable "game_server_protection_policy" {
  description = "Indicates whether instances in the game server group are protected from early termination. Valid values: NO_PROTECTION, FULL_PROTECTION. Defaults to NO_PROTECTION."
  type        = string
  default     = "NO_PROTECTION"

  validation {
    condition     = contains(["NO_PROTECTION", "FULL_PROTECTION"], var.game_server_protection_policy)
    error_message = "resource_aws_gamelift_game_server_group, game_server_protection_policy must be one of: NO_PROTECTION, FULL_PROTECTION."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = null
}

variable "vpc_subnets" {
  description = "A list of VPC subnets to use with instances in the game server group. By default, all GameLift FleetIQ-supported Availability Zones are used."
  type        = list(string)
  default     = null

  validation {
    condition     = var.vpc_subnets == null ? true : length(var.vpc_subnets) > 0
    error_message = "resource_aws_gamelift_game_server_group, vpc_subnets must contain at least one subnet if specified."
  }
}

variable "auto_scaling_policy" {
  description = "Configuration settings to define a scaling policy for the Auto Scaling group that is optimized for game hosting."
  type = object({
    estimated_instance_warmup = optional(number, 60)
    target_tracking_configuration = object({
      target_value = number
    })
  })
  default = null

  validation {
    condition = var.auto_scaling_policy == null ? true : (
      var.auto_scaling_policy.estimated_instance_warmup >= 0 &&
      var.auto_scaling_policy.target_tracking_configuration.target_value > 0
    )
    error_message = "resource_aws_gamelift_game_server_group, auto_scaling_policy estimated_instance_warmup must be non-negative and target_value must be greater than 0."
  }
}

variable "instance_definitions" {
  description = "The EC2 instance types and sizes to use in the Auto Scaling group. The instance definitions must specify at least two different instance types that are supported by GameLift FleetIQ."
  type = list(object({
    instance_type     = string
    weighted_capacity = optional(string)
  }))

  validation {
    condition     = length(var.instance_definitions) >= 2
    error_message = "resource_aws_gamelift_game_server_group, instance_definitions must specify at least two different instance types."
  }

  validation {
    condition = length(var.instance_definitions) == length(distinct([
      for def in var.instance_definitions : def.instance_type
    ]))
    error_message = "resource_aws_gamelift_game_server_group, instance_definitions must specify different instance types."
  }

  validation {
    condition = alltrue([
      for def in var.instance_definitions : length(def.instance_type) > 0
    ])
    error_message = "resource_aws_gamelift_game_server_group, instance_definitions instance_type must not be empty."
  }
}

variable "launch_template" {
  description = "The EC2 launch template that contains configuration settings and game server code to be deployed to all instances in the game server group."
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = optional(string)
  })
  default = null

  validation {
    condition = var.launch_template == null ? true : (
      (var.launch_template.id != null && var.launch_template.name == null) ||
      (var.launch_template.id == null && var.launch_template.name != null) ||
      (var.launch_template.id != null && var.launch_template.name != null)
    )
    error_message = "resource_aws_gamelift_game_server_group, launch_template must specify either id or name (or both)."
  }
}