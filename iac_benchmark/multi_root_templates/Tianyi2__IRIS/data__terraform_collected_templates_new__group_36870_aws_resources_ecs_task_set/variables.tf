variable "service" {
  description = "The short name or ARN of the ECS service"
  type        = string

  validation {
    condition     = length(var.service) > 0
    error_message = "resource_aws_ecs_task_set, service must be a non-empty string."
  }
}

variable "cluster" {
  description = "The short name or ARN of the cluster that hosts the service to create the task set in"
  type        = string

  validation {
    condition     = length(var.cluster) > 0
    error_message = "resource_aws_ecs_task_set, cluster must be a non-empty string."
  }
}

variable "task_definition" {
  description = "The family and revision (family:revision) or full ARN of the task definition that you want to run in your service"
  type        = string

  validation {
    condition     = length(var.task_definition) > 0
    error_message = "resource_aws_ecs_task_set, task_definition must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "capacity_provider_strategy" {
  description = "The capacity provider strategy to use for the service. Can be one or more"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for cps in var.capacity_provider_strategy : cps.weight >= 0
    ])
    error_message = "resource_aws_ecs_task_set, capacity_provider_strategy weight must be >= 0."
  }

  validation {
    condition = alltrue([
      for cps in var.capacity_provider_strategy : length(cps.capacity_provider) > 0
    ])
    error_message = "resource_aws_ecs_task_set, capacity_provider_strategy capacity_provider must be a non-empty string."
  }

  validation {
    condition = length([
      for cps in var.capacity_provider_strategy : cps if cps.base != null
    ]) <= 1
    error_message = "resource_aws_ecs_task_set, capacity_provider_strategy only one capacity provider can have a base defined."
  }
}

variable "external_id" {
  description = "The external ID associated with the task set"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "Whether to allow deleting the task set without waiting for scaling down to 0"
  type        = bool
  default     = null
}

variable "launch_type" {
  description = "The launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL"
  type        = string
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "FARGATE", "EXTERNAL"], var.launch_type)
    error_message = "resource_aws_ecs_task_set, launch_type must be one of: EC2, FARGATE, EXTERNAL."
  }
}

variable "load_balancer" {
  description = "Details on load balancers that are used with a task set"
  type = object({
    container_name     = string
    load_balancer_name = optional(string)
    target_group_arn   = optional(string)
    container_port     = optional(number, 0)
  })
  default = null

  validation {
    condition = var.load_balancer == null || (
      var.load_balancer != null && length(var.load_balancer.container_name) > 0
    )
    error_message = "resource_aws_ecs_task_set, load_balancer container_name must be a non-empty string."
  }

  validation {
    condition = var.load_balancer == null || (
      var.load_balancer != null &&
      (var.load_balancer.container_port == null || var.load_balancer.container_port >= 0)
    )
    error_message = "resource_aws_ecs_task_set, load_balancer container_port must be >= 0."
  }
}

variable "platform_version" {
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE"
  type        = string
  default     = "LATEST"
}

variable "network_configuration" {
  description = "The network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode"
  type = object({
    subnets          = list(string)
    security_groups  = optional(list(string))
    assign_public_ip = optional(bool, false)
  })
  default = null

  validation {
    condition = var.network_configuration == null || (
      var.network_configuration != null && length(var.network_configuration.subnets) > 0 && length(var.network_configuration.subnets) <= 16
    )
    error_message = "resource_aws_ecs_task_set, network_configuration subnets must contain between 1 and 16 elements."
  }

  validation {
    condition = var.network_configuration == null || (
      var.network_configuration != null &&
      (var.network_configuration.security_groups == null || length(var.network_configuration.security_groups) <= 5)
    )
    error_message = "resource_aws_ecs_task_set, network_configuration security_groups must contain at most 5 elements."
  }

  validation {
    condition = var.network_configuration == null || (
      var.network_configuration != null &&
      (var.network_configuration.assign_public_ip == null ||
        var.network_configuration.assign_public_ip == true ||
      var.network_configuration.assign_public_ip == false)
    )
    error_message = "resource_aws_ecs_task_set, network_configuration assign_public_ip must be true or false."
  }
}

variable "scale" {
  description = "A floating-point percentage of the desired number of tasks to place and keep running in the task set"
  type = object({
    unit  = optional(string, "PERCENT")
    value = optional(number, 0.0)
  })
  default = null

  validation {
    condition = var.scale == null || (
      var.scale != null && var.scale.value >= 0.0 && var.scale.value <= 100.0
    )
    error_message = "resource_aws_ecs_task_set, scale value must be between 0.0 and 100.0."
  }
}

variable "service_registries" {
  description = "The service discovery registries for the service. The maximum number of service_registries blocks is 1"
  type = object({
    registry_arn   = string
    port           = optional(number)
    container_port = optional(number)
    container_name = optional(string)
  })
  default = null

  validation {
    condition = var.service_registries == null || (
      var.service_registries != null && length(var.service_registries.registry_arn) > 0
    )
    error_message = "resource_aws_ecs_task_set, service_registries registry_arn must be a non-empty string."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "wait_until_stable" {
  description = "Whether terraform should wait until the task set has reached STEADY_STATE"
  type        = bool
  default     = null
}

variable "wait_until_stable_timeout" {
  description = "Wait timeout for task set to reach STEADY_STATE. Valid time units include ns, us (or µs), ms, s, m, and h"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[numshµ]?[sm]?$", var.wait_until_stable_timeout))
    error_message = "resource_aws_ecs_task_set, wait_until_stable_timeout must be a valid time duration (e.g., 10m, 5s, 1h)."
  }
}