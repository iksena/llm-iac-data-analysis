variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "capacity_providers" {
  description = "Set of names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  type        = set(string)
  default     = null

  validation {
    condition = var.capacity_providers == null || alltrue([
      for cp in var.capacity_providers :
      can(regex("^[a-zA-Z0-9_-]+$", cp)) || contains(["FARGATE", "FARGATE_SPOT"], cp)
    ])
    error_message = "resource_aws_ecs_cluster_capacity_providers, capacity_providers must contain valid capacity provider names or FARGATE/FARGATE_SPOT."
  }
}

variable "cluster_name" {
  description = "Name of the ECS cluster to manage capacity providers for."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.cluster_name))
    error_message = "resource_aws_ecs_cluster_capacity_providers, cluster_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "default_capacity_provider_strategy" {
  description = "Set of capacity provider strategies to use by default for the cluster."
  type = list(object({
    capacity_provider = string
    weight            = optional(number, 0)
    base              = optional(number, 0)
  }))
  default = []

  validation {
    condition = length([
      for strategy in var.default_capacity_provider_strategy :
      strategy if strategy.base > 0
    ]) <= 1
    error_message = "resource_aws_ecs_cluster_capacity_providers, default_capacity_provider_strategy only one capacity provider in a strategy can have a base defined."
  }

  validation {
    condition = alltrue([
      for strategy in var.default_capacity_provider_strategy :
      can(regex("^[a-zA-Z0-9_-]+$", strategy.capacity_provider)) || contains(["FARGATE", "FARGATE_SPOT"], strategy.capacity_provider)
    ])
    error_message = "resource_aws_ecs_cluster_capacity_providers, default_capacity_provider_strategy capacity_provider must be a valid capacity provider name or FARGATE/FARGATE_SPOT."
  }

  validation {
    condition = alltrue([
      for strategy in var.default_capacity_provider_strategy :
      strategy.weight >= 0
    ])
    error_message = "resource_aws_ecs_cluster_capacity_providers, default_capacity_provider_strategy weight must be greater than or equal to 0."
  }

  validation {
    condition = alltrue([
      for strategy in var.default_capacity_provider_strategy :
      strategy.base >= 0
    ])
    error_message = "resource_aws_ecs_cluster_capacity_providers, default_capacity_provider_strategy base must be greater than or equal to 0."
  }
}