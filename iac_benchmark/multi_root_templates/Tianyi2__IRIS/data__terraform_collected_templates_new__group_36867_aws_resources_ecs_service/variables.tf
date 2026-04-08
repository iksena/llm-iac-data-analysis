variable "name" {
  description = "Name of the service (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,255}$", var.name))
    error_message = "resource_aws_ecs_service, name must be 1-255 characters long and contain only letters, numbers, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "alarms" {
  description = "Information about the CloudWatch alarms"
  type = object({
    alarm_names = list(string)
    enable      = bool
    rollback    = bool
  })
  default = null

  validation {
    condition = var.alarms == null || (
      length(var.alarms.alarm_names) > 0 &&
      var.alarms.enable != null &&
      var.alarms.rollback != null
    )
    error_message = "resource_aws_ecs_service, alarms must have alarm_names list with at least one element, enable and rollback must be boolean."
  }
}

variable "availability_zone_rebalancing" {
  description = "ECS automatically redistributes tasks within a service across Availability Zones"
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone_rebalancing == null || contains(["ENABLED", "DISABLED"], var.availability_zone_rebalancing)
    error_message = "resource_aws_ecs_service, availability_zone_rebalancing must be ENABLED or DISABLED."
  }
}

variable "capacity_provider_strategy" {
  description = "Capacity provider strategies to use for the service"
  type = list(object({
    base              = optional(number)
    capacity_provider = string
    weight            = number
  }))
  default = []

  validation {
    condition = length([
      for strategy in var.capacity_provider_strategy : strategy
      if strategy.base != null
    ]) <= 1
    error_message = "resource_aws_ecs_service, capacity_provider_strategy only one strategy can have a base defined."
  }
}

variable "cluster" {
  description = "ARN of an ECS cluster"
  type        = string
  default     = null
}

variable "deployment_circuit_breaker" {
  description = "Configuration block for deployment circuit breaker"
  type = object({
    enable   = bool
    rollback = bool
  })
  default = null
}

variable "deployment_configuration" {
  description = "Configuration block for deployment settings"
  type = object({
    strategy             = optional(string, "ROLLING")
    bake_time_in_minutes = optional(number)
    lifecycle_hook = optional(object({
      hook_target_arn  = string
      role_arn         = string
      lifecycle_stages = list(string)
    }))
  })
  default = null

  validation {
    condition = var.deployment_configuration == null || (
      contains(["ROLLING", "BLUE_GREEN"], var.deployment_configuration.strategy)
    )
    error_message = "resource_aws_ecs_service, deployment_configuration strategy must be ROLLING or BLUE_GREEN."
  }

  validation {
    condition = var.deployment_configuration == null || var.deployment_configuration.lifecycle_hook == null || (
      var.deployment_configuration.lifecycle_hook.lifecycle_stages != null &&
      length(var.deployment_configuration.lifecycle_hook.lifecycle_stages) > 0 &&
      alltrue([
        for stage in var.deployment_configuration.lifecycle_hook.lifecycle_stages :
        contains([
          "RECONCILE_SERVICE",
          "PRE_SCALE_UP",
          "POST_SCALE_UP",
          "TEST_TRAFFIC_SHIFT",
          "POST_TEST_TRAFFIC_SHIFT",
          "PRODUCTION_TRAFFIC_SHIFT",
          "POST_PRODUCTION_TRAFFIC_SHIFT"
        ], stage)
      ])
    )
    error_message = "resource_aws_ecs_service, deployment_configuration lifecycle_hook lifecycle_stages must contain valid deployment stages."
  }
}

variable "deployment_controller" {
  description = "Configuration block for deployment controller configuration"
  type = object({
    type = optional(string, "ECS")
  })
  default = null

  validation {
    condition = var.deployment_controller == null || (
      contains(["CODE_DEPLOY", "ECS", "EXTERNAL"], var.deployment_controller.type)
    )
    error_message = "resource_aws_ecs_service, deployment_controller type must be CODE_DEPLOY, ECS, or EXTERNAL."
  }
}

variable "deployment_maximum_percent" {
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = null

  validation {
    condition     = var.deployment_maximum_percent == null || var.deployment_maximum_percent >= 0
    error_message = "resource_aws_ecs_service, deployment_maximum_percent must be greater than or equal to 0."
  }
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = null

  validation {
    condition     = var.deployment_minimum_healthy_percent == null || var.deployment_minimum_healthy_percent >= 0
    error_message = "resource_aws_ecs_service, deployment_minimum_healthy_percent must be greater than or equal to 0."
  }
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 0

  validation {
    condition     = var.desired_count >= 0
    error_message = "resource_aws_ecs_service, desired_count must be greater than or equal to 0."
  }
}

variable "enable_ecs_managed_tags" {
  description = "Whether to enable Amazon ECS managed tags for the tasks within the service"
  type        = bool
  default     = null
}

variable "enable_execute_command" {
  description = "Whether to enable Amazon ECS Exec for the tasks within the service"
  type        = bool
  default     = null
}

variable "force_delete" {
  description = "Enable to delete a service even if it wasn't scaled down to zero tasks"
  type        = bool
  default     = null
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service"
  type        = bool
  default     = null
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown"
  type        = number
  default     = null

  validation {
    condition     = var.health_check_grace_period_seconds == null || (var.health_check_grace_period_seconds >= 0 && var.health_check_grace_period_seconds <= 2147483647)
    error_message = "resource_aws_ecs_service, health_check_grace_period_seconds must be between 0 and 2147483647."
  }
}

variable "iam_role" {
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf"
  type        = string
  default     = null
}

variable "launch_type" {
  description = "Launch type on which to run your service"
  type        = string
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "FARGATE", "EXTERNAL"], var.launch_type)
    error_message = "resource_aws_ecs_service, launch_type must be EC2, FARGATE, or EXTERNAL."
  }
}

variable "load_balancer" {
  description = "Configuration block for load balancers"
  type = list(object({
    elb_name         = optional(string)
    target_group_arn = optional(string)
    container_name   = string
    container_port   = number
    advanced_configuration = optional(object({
      alternate_target_group_arn = string
      production_listener_rule   = string
      role_arn                   = string
      test_listener_rule         = optional(string)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for lb in var.load_balancer :
      (lb.elb_name != null && lb.target_group_arn == null) ||
      (lb.elb_name == null && lb.target_group_arn != null)
    ])
    error_message = "resource_aws_ecs_service, load_balancer must specify either elb_name or target_group_arn, but not both."
  }
}

variable "network_configuration" {
  description = "Network configuration for the service"
  type = object({
    subnets          = list(string)
    security_groups  = optional(list(string))
    assign_public_ip = optional(bool, false)
  })
  default = null

  validation {
    condition = var.network_configuration == null || (
      length(var.network_configuration.subnets) > 0
    )
    error_message = "resource_aws_ecs_service, network_configuration subnets must contain at least one subnet."
  }

  validation {
    condition = var.network_configuration == null || (
      contains([true, false], var.network_configuration.assign_public_ip)
    )
    error_message = "resource_aws_ecs_service, network_configuration assign_public_ip must be true or false."
  }
}

variable "ordered_placement_strategy" {
  description = "Service level strategy rules that are taken into consideration during task placement"
  type = list(object({
    type  = string
    field = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.ordered_placement_strategy) <= 5
    error_message = "resource_aws_ecs_service, ordered_placement_strategy maximum number of strategies is 5."
  }

  validation {
    condition = alltrue([
      for strategy in var.ordered_placement_strategy :
      contains(["binpack", "random", "spread"], strategy.type)
    ])
    error_message = "resource_aws_ecs_service, ordered_placement_strategy type must be binpack, random, or spread."
  }
}

variable "placement_constraints" {
  description = "Rules that are taken into consideration during task placement"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.placement_constraints) <= 10
    error_message = "resource_aws_ecs_service, placement_constraints maximum number of constraints is 10."
  }

  validation {
    condition = alltrue([
      for constraint in var.placement_constraints :
      contains(["memberOf", "distinctInstance"], constraint.type)
    ])
    error_message = "resource_aws_ecs_service, placement_constraints type must be memberOf or distinctInstance."
  }
}

variable "platform_version" {
  description = "Platform version on which to run your service"
  type        = string
  default     = "LATEST"
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the task definition or the service to the tasks"
  type        = string
  default     = null

  validation {
    condition     = var.propagate_tags == null || contains(["SERVICE", "TASK_DEFINITION"], var.propagate_tags)
    error_message = "resource_aws_ecs_service, propagate_tags must be SERVICE or TASK_DEFINITION."
  }
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service"
  type        = string
  default     = "REPLICA"

  validation {
    condition     = contains(["REPLICA", "DAEMON"], var.scheduling_strategy)
    error_message = "resource_aws_ecs_service, scheduling_strategy must be REPLICA or DAEMON."
  }
}

variable "service_connect_configuration" {
  description = "ECS Service Connect configuration for this service"
  type = object({
    enabled   = bool
    namespace = optional(string)
    log_configuration = optional(object({
      log_driver = string
      options    = optional(map(string))
      secret_option = optional(list(object({
        name       = string
        value_from = string
      })))
    }))
    service = optional(list(object({
      discovery_name        = optional(string)
      ingress_port_override = optional(number)
      port_name             = string
      client_alias = optional(list(object({
        dns_name = optional(string)
        port     = number
        test_traffic_rules = optional(object({
          header = optional(list(object({
            name = string
            value = object({
              exact = string
            })
          })))
        }))
      })))
      timeout = optional(object({
        idle_timeout_seconds        = optional(number)
        per_request_timeout_seconds = optional(number)
      }))
      tls = optional(object({
        kms_key  = optional(string)
        role_arn = optional(string)
        issuer_cert_authority = object({
          aws_pca_authority_arn = optional(string)
        })
      }))
    })))
  })
  default = null
}

variable "service_registries" {
  description = "Service discovery registries for the service"
  type = object({
    registry_arn   = string
    port           = optional(number)
    container_port = optional(number)
    container_name = optional(string)
  })
  default = null
}

variable "sigint_rollback" {
  description = "Whether to enable graceful termination of deployments using SIGINT signals"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "task_definition" {
  description = "Family and revision (family:revision) or full ARN of the task definition that you want to run in your service"
  type        = string
  default     = null
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger an in-place update (redeployment)"
  type        = map(string)
  default     = {}
}

variable "volume_configuration" {
  description = "Configuration for a volume specified in the task definition"
  type = list(object({
    name = string
    managed_ebs_volume = object({
      role_arn                   = string
      encrypted                  = optional(bool, true)
      file_system_type           = optional(string, "xfs")
      iops                       = optional(number)
      kms_key_id                 = optional(string)
      size_in_gb                 = optional(number)
      snapshot_id                = optional(string)
      throughput                 = optional(number)
      volume_initialization_rate = optional(number)
      volume_type                = optional(string)
      tag_specifications = optional(list(object({
        resource_type  = string
        propagate_tags = optional(bool)
        tags           = optional(map(string))
      })))
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for vol in var.volume_configuration :
      vol.managed_ebs_volume.size_in_gb != null || vol.managed_ebs_volume.snapshot_id != null
    ])
    error_message = "resource_aws_ecs_service, volume_configuration managed_ebs_volume must specify either size_in_gb or snapshot_id."
  }

  validation {
    condition = alltrue([
      for vol in var.volume_configuration :
      vol.managed_ebs_volume.file_system_type == null ||
      contains(["ext3", "ext4", "xfs"], vol.managed_ebs_volume.file_system_type)
    ])
    error_message = "resource_aws_ecs_service, volume_configuration managed_ebs_volume file_system_type must be ext3, ext4, or xfs."
  }

  validation {
    condition = alltrue([
      for vol in var.volume_configuration :
      vol.managed_ebs_volume.tag_specifications == null ||
      alltrue([
        for tag_spec in vol.managed_ebs_volume.tag_specifications :
        tag_spec.resource_type == "volume"
      ])
    ])
    error_message = "resource_aws_ecs_service, volume_configuration managed_ebs_volume tag_specifications resource_type must be volume."
  }
}

variable "vpc_lattice_configurations" {
  description = "The VPC Lattice configuration for your service"
  type = list(object({
    role_arn         = string
    target_group_arn = string
    port_name        = string
  }))
  default = []
}

variable "wait_for_steady_state" {
  description = "If true, Terraform will wait for the service to reach a steady state before continuing"
  type        = bool
  default     = false
}