variable "family" {
  description = "A unique name for your task definition"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.family))
    error_message = "resource_aws_ecs_task_definition, family must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document"
  type        = string

  validation {
    condition     = can(jsondecode(var.container_definitions))
    error_message = "resource_aws_ecs_task_definition, container_definitions must be valid JSON."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "cpu" {
  description = "Number of cpu units used by the task"
  type        = number
  default     = null

  validation {
    condition     = var.cpu == null || var.cpu > 0
    error_message = "resource_aws_ecs_task_definition, cpu must be greater than 0 when specified."
  }
}

variable "enable_fault_injection" {
  description = "Enables fault injection and allows for fault injection requests to be accepted from the task's containers"
  type        = bool
  default     = false
}

variable "execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
  type        = string
  default     = null

  validation {
    condition     = var.execution_role_arn == null || can(regex("^arn:aws:iam::", var.execution_role_arn))
    error_message = "resource_aws_ecs_task_definition, execution_role_arn must be a valid IAM role ARN when specified."
  }
}

variable "ipc_mode" {
  description = "IPC resource namespace to be used for the containers in the task"
  type        = string
  default     = null

  validation {
    condition     = var.ipc_mode == null || contains(["host", "task", "none"], var.ipc_mode)
    error_message = "resource_aws_ecs_task_definition, ipc_mode must be one of: host, task, none."
  }
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task"
  type        = number
  default     = null

  validation {
    condition     = var.memory == null || var.memory > 0
    error_message = "resource_aws_ecs_task_definition, memory must be greater than 0 when specified."
  }
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task"
  type        = string
  default     = null

  validation {
    condition     = var.network_mode == null || contains(["none", "bridge", "awsvpc", "host"], var.network_mode)
    error_message = "resource_aws_ecs_task_definition, network_mode must be one of: none, bridge, awsvpc, host."
  }
}

variable "runtime_platform" {
  description = "Configuration block for runtime_platform that containers in your task may use"
  type = object({
    operating_system_family = optional(string)
    cpu_architecture        = optional(string)
  })
  default = null

  validation {
    condition = var.runtime_platform == null || (
      var.runtime_platform.cpu_architecture == null || contains(["X86_64", "ARM64"], var.runtime_platform.cpu_architecture)
    )
    error_message = "resource_aws_ecs_task_definition, runtime_platform.cpu_architecture must be either X86_64 or ARM64 when specified."
  }
}

variable "pid_mode" {
  description = "Process namespace to use for the containers in the task"
  type        = string
  default     = null

  validation {
    condition     = var.pid_mode == null || contains(["host", "task"], var.pid_mode)
    error_message = "resource_aws_ecs_task_definition, pid_mode must be one of: host, task."
  }
}

variable "placement_constraints" {
  description = "Configuration block for rules that are taken into consideration during task placement"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.placement_constraints) <= 10
    error_message = "resource_aws_ecs_task_definition, placement_constraints maximum number is 10."
  }

  validation {
    condition = alltrue([
      for pc in var.placement_constraints : contains(["memberOf"], pc.type)
    ])
    error_message = "resource_aws_ecs_task_definition, placement_constraints type must be memberOf."
  }
}

variable "proxy_configuration" {
  description = "Configuration block for the App Mesh proxy"
  type = object({
    type           = optional(string)
    container_name = string
    properties     = map(string)
  })
  default = null

  validation {
    condition     = var.proxy_configuration == null || var.proxy_configuration.type == null || var.proxy_configuration.type == "APPMESH"
    error_message = "resource_aws_ecs_task_definition, proxy_configuration.type must be APPMESH when specified."
  }
}

variable "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task"
  type = object({
    size_in_gib = number
  })
  default = null

  validation {
    condition     = var.ephemeral_storage == null || (var.ephemeral_storage.size_in_gib >= 21 && var.ephemeral_storage.size_in_gib <= 200)
    error_message = "resource_aws_ecs_task_definition, ephemeral_storage.size_in_gib must be between 21 and 200 GiB."
  }
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task"
  type        = list(string)
  default     = null

  validation {
    condition = var.requires_compatibilities == null || alltrue([
      for rc in var.requires_compatibilities : contains(["EC2", "FARGATE"], rc)
    ])
    error_message = "resource_aws_ecs_task_definition, requires_compatibilities must contain only EC2 and/or FARGATE."
  }
}

variable "skip_destroy" {
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  type        = string
  default     = null

  validation {
    condition     = var.task_role_arn == null || can(regex("^arn:aws:iam::", var.task_role_arn))
    error_message = "resource_aws_ecs_task_definition, task_role_arn must be a valid IAM role ARN when specified."
  }
}

variable "track_latest" {
  description = "Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state"
  type        = bool
  default     = false
}

variable "volume" {
  description = "Configuration block for volumes that containers in your task may use"
  type = list(object({
    name                = string
    host_path           = optional(string)
    configure_at_launch = optional(bool)
    docker_volume_configuration = optional(object({
      scope         = optional(string)
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(string))
      labels        = optional(map(string))
    }))
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
      authorization_config = optional(object({
        access_point_id = optional(string)
        iam             = optional(string)
      }))
    }))
    fsx_windows_file_server_volume_configuration = optional(object({
      file_system_id = string
      root_directory = string
      authorization_config = object({
        credentials_parameter = string
        domain                = string
      })
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for v in var.volume : v.docker_volume_configuration == null || v.docker_volume_configuration.scope == null || contains(["task", "shared"], v.docker_volume_configuration.scope)
    ])
    error_message = "resource_aws_ecs_task_definition, volume docker_volume_configuration.scope must be either task or shared when specified."
  }

  validation {
    condition = alltrue([
      for v in var.volume : v.efs_volume_configuration == null || v.efs_volume_configuration.transit_encryption == null || contains(["ENABLED", "DISABLED"], v.efs_volume_configuration.transit_encryption)
    ])
    error_message = "resource_aws_ecs_task_definition, volume efs_volume_configuration.transit_encryption must be either ENABLED or DISABLED when specified."
  }

  validation {
    condition = alltrue([
      for v in var.volume : v.efs_volume_configuration == null || v.efs_volume_configuration.authorization_config == null || v.efs_volume_configuration.authorization_config.iam == null || contains(["ENABLED", "DISABLED"], v.efs_volume_configuration.authorization_config.iam)
    ])
    error_message = "resource_aws_ecs_task_definition, volume efs_volume_configuration.authorization_config.iam must be either ENABLED or DISABLED when specified."
  }
}