variable "deployment_config_name" {
  description = "The name of the deployment config"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.deployment_config_name))
    error_message = "resource_aws_codedeploy_deployment_config, deployment_config_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "compute_platform" {
  description = "The compute platform can be Server, Lambda, or ECS. Default is Server"
  type        = string
  default     = "Server"

  validation {
    condition     = contains(["Server", "Lambda", "ECS"], var.compute_platform)
    error_message = "resource_aws_codedeploy_deployment_config, compute_platform must be one of: Server, Lambda, ECS."
  }
}

variable "minimum_healthy_hosts" {
  description = "A minimum_healthy_hosts block. Required for Server compute platform"
  type = object({
    type  = string
    value = number
  })
  default = null

  validation {
    condition     = var.minimum_healthy_hosts == null ? true : contains(["FLEET_PERCENT", "HOST_COUNT"], var.minimum_healthy_hosts.type)
    error_message = "resource_aws_codedeploy_deployment_config, minimum_healthy_hosts type must be either FLEET_PERCENT or HOST_COUNT."
  }

  validation {
    condition     = var.minimum_healthy_hosts == null ? true : var.minimum_healthy_hosts.value >= 0
    error_message = "resource_aws_codedeploy_deployment_config, minimum_healthy_hosts value must be greater than or equal to 0."
  }
}

variable "traffic_routing_config" {
  description = "A traffic_routing_config block. Traffic Routing Config is documented below"
  type = object({
    type = optional(string)
    time_based_canary = optional(object({
      interval   = optional(number)
      percentage = optional(number)
    }))
    time_based_linear = optional(object({
      interval   = optional(number)
      percentage = optional(number)
    }))
  })
  default = null

  validation {
    condition     = var.traffic_routing_config == null ? true : var.traffic_routing_config.type == null ? true : contains(["TimeBasedCanary", "TimeBasedLinear", "AllAtOnce"], var.traffic_routing_config.type)
    error_message = "resource_aws_codedeploy_deployment_config, traffic_routing_config type must be one of: TimeBasedCanary, TimeBasedLinear, AllAtOnce."
  }

  validation {
    condition     = var.traffic_routing_config == null ? true : var.traffic_routing_config.time_based_canary == null ? true : var.traffic_routing_config.time_based_canary.interval == null ? true : var.traffic_routing_config.time_based_canary.interval > 0
    error_message = "resource_aws_codedeploy_deployment_config, traffic_routing_config time_based_canary interval must be greater than 0."
  }

  validation {
    condition     = var.traffic_routing_config == null ? true : var.traffic_routing_config.time_based_canary == null ? true : var.traffic_routing_config.time_based_canary.percentage == null ? true : (var.traffic_routing_config.time_based_canary.percentage >= 0 && var.traffic_routing_config.time_based_canary.percentage <= 100)
    error_message = "resource_aws_codedeploy_deployment_config, traffic_routing_config time_based_canary percentage must be between 0 and 100."
  }

  validation {
    condition     = var.traffic_routing_config == null ? true : var.traffic_routing_config.time_based_linear == null ? true : var.traffic_routing_config.time_based_linear.interval == null ? true : var.traffic_routing_config.time_based_linear.interval > 0
    error_message = "resource_aws_codedeploy_deployment_config, traffic_routing_config time_based_linear interval must be greater than 0."
  }

  validation {
    condition     = var.traffic_routing_config == null ? true : var.traffic_routing_config.time_based_linear == null ? true : var.traffic_routing_config.time_based_linear.percentage == null ? true : (var.traffic_routing_config.time_based_linear.percentage >= 0 && var.traffic_routing_config.time_based_linear.percentage <= 100)
    error_message = "resource_aws_codedeploy_deployment_config, traffic_routing_config time_based_linear percentage must be between 0 and 100."
  }
}

variable "zonal_config" {
  description = "A zonal_config block. Zonal Config is documented below"
  type = object({
    first_zone_monitor_duration_in_seconds = optional(number)
    monitor_duration_in_seconds            = optional(number)
    minimum_healthy_hosts_per_zone = optional(object({
      type  = string
      value = number
    }))
  })
  default = null

  validation {
    condition     = var.zonal_config == null ? true : var.zonal_config.first_zone_monitor_duration_in_seconds == null ? true : var.zonal_config.first_zone_monitor_duration_in_seconds >= 0
    error_message = "resource_aws_codedeploy_deployment_config, zonal_config first_zone_monitor_duration_in_seconds must be greater than or equal to 0."
  }

  validation {
    condition     = var.zonal_config == null ? true : var.zonal_config.monitor_duration_in_seconds == null ? true : var.zonal_config.monitor_duration_in_seconds >= 0
    error_message = "resource_aws_codedeploy_deployment_config, zonal_config monitor_duration_in_seconds must be greater than or equal to 0."
  }

  validation {
    condition     = var.zonal_config == null ? true : var.zonal_config.minimum_healthy_hosts_per_zone == null ? true : contains(["FLEET_PERCENT", "HOST_COUNT"], var.zonal_config.minimum_healthy_hosts_per_zone.type)
    error_message = "resource_aws_codedeploy_deployment_config, zonal_config minimum_healthy_hosts_per_zone type must be either FLEET_PERCENT or HOST_COUNT."
  }

  validation {
    condition     = var.zonal_config == null ? true : var.zonal_config.minimum_healthy_hosts_per_zone == null ? true : var.zonal_config.minimum_healthy_hosts_per_zone.value >= 0
    error_message = "resource_aws_codedeploy_deployment_config, zonal_config minimum_healthy_hosts_per_zone value must be greater than or equal to 0."
  }
}