variable "cluster" {
  description = "Short name or full Amazon Resource Name (ARN) of the cluster to run the task on."
  type        = string

  validation {
    condition     = length(var.cluster) > 0
    error_message = "data_aws_ecs_task_execution, cluster must be a non-empty string."
  }
}

variable "task_definition" {
  description = "The family and revision (family:revision) or full ARN of the task definition to run. If a revision isn't specified, the latest ACTIVE revision is used."
  type        = string

  validation {
    condition     = length(var.task_definition) > 0
    error_message = "data_aws_ecs_task_execution, task_definition must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "capacity_provider_strategy" {
  description = "Set of capacity provider strategies to use for the cluster."
  type = list(object({
    capacity_provider = string
    base              = optional(number, 0)
    weight            = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for strategy in var.capacity_provider_strategy :
      length(strategy.capacity_provider) > 0
    ])
    error_message = "data_aws_ecs_task_execution, capacity_provider_strategy capacity_provider must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for strategy in var.capacity_provider_strategy :
      strategy.base >= 0
    ])
    error_message = "data_aws_ecs_task_execution, capacity_provider_strategy base must be >= 0."
  }

  validation {
    condition = alltrue([
      for strategy in var.capacity_provider_strategy :
      strategy.weight >= 0
    ])
    error_message = "data_aws_ecs_task_execution, capacity_provider_strategy weight must be >= 0."
  }
}

variable "client_token" {
  description = "An identifier that you provide to ensure the idempotency of the request. It must be unique and is case sensitive. Up to 64 characters are allowed. The valid characters are characters in the range of 33-126, inclusive."
  type        = string
  default     = null

  validation {
    condition     = var.client_token == null || (length(var.client_token) <= 64 && can(regex("^[!-~]*$", var.client_token)))
    error_message = "data_aws_ecs_task_execution, client_token must be <= 64 characters and contain only ASCII printable characters (33-126)."
  }
}

variable "desired_count" {
  description = "Number of instantiations of the specified task to place on your cluster. You can specify up to 10 tasks for each call."
  type        = number
  default     = null

  validation {
    condition     = var.desired_count == null || (var.desired_count >= 1 && var.desired_count <= 10)
    error_message = "data_aws_ecs_task_execution, desired_count must be between 1 and 10."
  }
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service."
  type        = bool
  default     = null
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  type        = bool
  default     = null
}

variable "group" {
  description = "Name of the task group to associate with the task. The default value is the family name of the task definition."
  type        = string
  default     = null
}

variable "launch_type" {
  description = "Launch type on which to run your service. Valid values are EC2, FARGATE, and EXTERNAL."
  type        = string
  default     = null

  validation {
    condition     = var.launch_type == null || contains(["EC2", "FARGATE", "EXTERNAL"], var.launch_type)
    error_message = "data_aws_ecs_task_execution, launch_type must be one of: EC2, FARGATE, EXTERNAL."
  }
}

variable "network_configuration" {
  description = "Network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes."
  type = object({
    subnets          = list(string)
    security_groups  = optional(list(string))
    assign_public_ip = optional(bool, false)
  })
  default = null

  validation {
    condition = var.network_configuration == null || (
      var.network_configuration.subnets != null &&
      length(var.network_configuration.subnets) > 0 &&
      alltrue([for subnet in var.network_configuration.subnets : length(subnet) > 0])
    )
    error_message = "data_aws_ecs_task_execution, network_configuration subnets must be a non-empty list of non-empty strings."
  }
}

variable "overrides" {
  description = "A list of container overrides that specify the name of a container in the specified task definition and the overrides it should receive."
  type = object({
    cpu                = optional(number)
    execution_role_arn = optional(string)
    memory             = optional(string)
    task_role_arn      = optional(string)
    container_overrides = optional(list(object({
      command            = optional(list(string))
      cpu                = optional(number)
      memory             = optional(number)
      memory_reservation = optional(number)
      name               = optional(string)
      environment = optional(list(object({
        key   = string
        value = string
      })), [])
      resource_requirements = optional(list(object({
        type  = string
        value = string
      })), [])
    })), [])
  })
  default = null

  validation {
    condition = var.overrides == null || (var.overrides.container_overrides == null || alltrue([
      for override in var.overrides.container_overrides :
      override.environment == null || alltrue([
        for env in override.environment :
        length(env.key) > 0 && length(env.value) > 0
      ])
    ]))
    error_message = "data_aws_ecs_task_execution, overrides container_overrides environment key and value must be non-empty strings."
  }

  validation {
    condition = var.overrides == null || (var.overrides.container_overrides == null || alltrue([
      for override in var.overrides.container_overrides :
      override.resource_requirements == null || alltrue([
        for req in override.resource_requirements :
        req.type == "GPU" && length(req.value) > 0
      ])
    ]))
    error_message = "data_aws_ecs_task_execution, overrides container_overrides resource_requirements type must be 'GPU' and value must be non-empty."
  }
}

variable "placement_constraints" {
  description = "An array of placement constraint objects to use for the task. You can specify up to 10 constraints for each task."
  type = list(object({
    expression = optional(string)
    type       = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.placement_constraints) <= 10
    error_message = "data_aws_ecs_task_execution, placement_constraints can have at most 10 constraints."
  }

  validation {
    condition = alltrue([
      for constraint in var.placement_constraints :
      constraint.type == null || contains(["distinctInstance", "memberOf"], constraint.type)
    ])
    error_message = "data_aws_ecs_task_execution, placement_constraints type must be 'distinctInstance' or 'memberOf'."
  }

  validation {
    condition = alltrue([
      for constraint in var.placement_constraints :
      constraint.type != "distinctInstance" || constraint.expression == null
    ])
    error_message = "data_aws_ecs_task_execution, placement_constraints expression cannot be specified when type is 'distinctInstance'."
  }

  validation {
    condition = alltrue([
      for constraint in var.placement_constraints :
      constraint.expression == null || length(constraint.expression) <= 2000
    ])
    error_message = "data_aws_ecs_task_execution, placement_constraints expression can have a maximum length of 2000 characters."
  }
}

variable "placement_strategy" {
  description = "The placement strategy objects to use for the task. You can specify a maximum of 5 strategy rules for each task."
  type = list(object({
    field = optional(string)
    type  = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.placement_strategy) <= 5
    error_message = "data_aws_ecs_task_execution, placement_strategy can have at most 5 strategy rules."
  }

  validation {
    condition = alltrue([
      for strategy in var.placement_strategy :
      strategy.type == null || contains(["random", "spread", "binpack"], strategy.type)
    ])
    error_message = "data_aws_ecs_task_execution, placement_strategy type must be 'random', 'spread', or 'binpack'."
  }
}

variable "platform_version" {
  description = "The platform version the task uses. A platform version is only specified for tasks hosted on Fargate. If one isn't specified, the LATEST platform version is used."
  type        = string
  default     = null
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition to the task. If no value is specified, the tags aren't propagated. An error will be received if you specify the SERVICE option when running a task. Valid values are TASK_DEFINITION or NONE."
  type        = string
  default     = null

  validation {
    condition     = var.propagate_tags == null || contains(["TASK_DEFINITION", "NONE"], var.propagate_tags)
    error_message = "data_aws_ecs_task_execution, propagate_tags must be 'TASK_DEFINITION' or 'NONE'."
  }
}

variable "reference_id" {
  description = "The reference ID to use for the task."
  type        = string
  default     = null
}

variable "started_by" {
  description = "An optional tag specified when a task is started."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}