variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app_name" {
  description = "The name of the application."
  type        = string

  validation {
    condition     = length(var.app_name) > 0
    error_message = "resource_aws_codedeploy_deployment_group, app_name cannot be empty."
  }
}

variable "deployment_group_name" {
  description = "The name of the deployment group."
  type        = string

  validation {
    condition     = length(var.deployment_group_name) > 0
    error_message = "resource_aws_codedeploy_deployment_group, deployment_group_name cannot be empty."
  }
}

variable "service_role_arn" {
  description = "The service role ARN that allows deployments."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.service_role_arn))
    error_message = "resource_aws_codedeploy_deployment_group, service_role_arn must be a valid IAM role ARN."
  }
}

variable "alarm_configuration" {
  description = "Configuration block of alarms associated with the deployment group."
  type = object({
    alarms                    = optional(list(string))
    enabled                   = optional(bool)
    ignore_poll_alarm_failure = optional(bool, false)
  })
  default = null
}

variable "auto_rollback_configuration" {
  description = "Configuration block of the automatic rollback configuration associated with the deployment group."
  type = object({
    enabled = optional(bool)
    events  = optional(list(string))
  })
  default = null

  validation {
    condition = var.auto_rollback_configuration == null || (
      var.auto_rollback_configuration.events == null ||
      alltrue([
        for event in var.auto_rollback_configuration.events :
        contains(["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM", "DEPLOYMENT_STOP_ON_REQUEST"], event)
      ])
    )
    error_message = "resource_aws_codedeploy_deployment_group, auto_rollback_configuration events must be one of: DEPLOYMENT_FAILURE, DEPLOYMENT_STOP_ON_ALARM, DEPLOYMENT_STOP_ON_REQUEST."
  }
}

variable "autoscaling_groups" {
  description = "Autoscaling groups associated with the deployment group."
  type        = list(string)
  default     = null
}

variable "blue_green_deployment_config" {
  description = "Configuration block of the blue/green deployment options for a deployment group."
  type = object({
    deployment_ready_option = optional(object({
      action_on_timeout    = optional(string)
      wait_time_in_minutes = optional(number)
    }))
    green_fleet_provisioning_option = optional(object({
      action = optional(string)
    }))
    terminate_blue_instances_on_deployment_success = optional(object({
      action                           = optional(string)
      termination_wait_time_in_minutes = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.blue_green_deployment_config == null || (
      var.blue_green_deployment_config.deployment_ready_option == null ||
      var.blue_green_deployment_config.deployment_ready_option.action_on_timeout == null ||
      contains(["CONTINUE_DEPLOYMENT", "STOP_DEPLOYMENT"], var.blue_green_deployment_config.deployment_ready_option.action_on_timeout)
    )
    error_message = "resource_aws_codedeploy_deployment_group, blue_green_deployment_config.deployment_ready_option.action_on_timeout must be CONTINUE_DEPLOYMENT or STOP_DEPLOYMENT."
  }

  validation {
    condition = var.blue_green_deployment_config == null || (
      var.blue_green_deployment_config.green_fleet_provisioning_option == null ||
      var.blue_green_deployment_config.green_fleet_provisioning_option.action == null ||
      contains(["DISCOVER_EXISTING", "COPY_AUTO_SCALING_GROUP"], var.blue_green_deployment_config.green_fleet_provisioning_option.action)
    )
    error_message = "resource_aws_codedeploy_deployment_group, blue_green_deployment_config.green_fleet_provisioning_option.action must be DISCOVER_EXISTING or COPY_AUTO_SCALING_GROUP."
  }

  validation {
    condition = var.blue_green_deployment_config == null || (
      var.blue_green_deployment_config.terminate_blue_instances_on_deployment_success == null ||
      var.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action == null ||
      contains(["TERMINATE", "KEEP_ALIVE"], var.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action)
    )
    error_message = "resource_aws_codedeploy_deployment_group, blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action must be TERMINATE or KEEP_ALIVE."
  }
}

variable "deployment_config_name" {
  description = "The name of the group's deployment config. The default is 'CodeDeployDefault.OneAtATime'."
  type        = string
  default     = null
}

variable "deployment_style" {
  description = "Configuration block of the type of deployment, either in-place or blue/green, you want to run and whether to route deployment traffic behind a load balancer."
  type = object({
    deployment_option = optional(string, "WITHOUT_TRAFFIC_CONTROL")
    deployment_type   = optional(string, "IN_PLACE")
  })
  default = null

  validation {
    condition = var.deployment_style == null || (
      var.deployment_style.deployment_option == null ||
      contains(["WITH_TRAFFIC_CONTROL", "WITHOUT_TRAFFIC_CONTROL"], var.deployment_style.deployment_option)
    )
    error_message = "resource_aws_codedeploy_deployment_group, deployment_style.deployment_option must be WITH_TRAFFIC_CONTROL or WITHOUT_TRAFFIC_CONTROL."
  }

  validation {
    condition = var.deployment_style == null || (
      var.deployment_style.deployment_type == null ||
      contains(["IN_PLACE", "BLUE_GREEN"], var.deployment_style.deployment_type)
    )
    error_message = "resource_aws_codedeploy_deployment_group, deployment_style.deployment_type must be IN_PLACE or BLUE_GREEN."
  }
}

variable "ec2_tag_filter" {
  description = "Tag filters associated with the deployment group."
  type = list(object({
    key   = optional(string)
    type  = optional(string)
    value = optional(string)
  }))
  default = null

  validation {
    condition = var.ec2_tag_filter == null || alltrue([
      for filter in var.ec2_tag_filter :
      filter.type == null || contains(["KEY_ONLY", "VALUE_ONLY", "KEY_AND_VALUE"], filter.type)
    ])
    error_message = "resource_aws_codedeploy_deployment_group, ec2_tag_filter.type must be KEY_ONLY, VALUE_ONLY, or KEY_AND_VALUE."
  }
}

variable "ec2_tag_set" {
  description = "Configuration blocks of Tag filters associated with the deployment group, which are also referred to as tag groups."
  type = list(object({
    ec2_tag_filter = optional(list(object({
      key   = optional(string)
      type  = optional(string)
      value = optional(string)
    })))
  }))
  default = null

  validation {
    condition = var.ec2_tag_set == null || alltrue([
      for tag_set in var.ec2_tag_set :
      tag_set.ec2_tag_filter == null || alltrue([
        for filter in tag_set.ec2_tag_filter :
        filter.type == null || contains(["KEY_ONLY", "VALUE_ONLY", "KEY_AND_VALUE"], filter.type)
      ])
    ])
    error_message = "resource_aws_codedeploy_deployment_group, ec2_tag_set.ec2_tag_filter.type must be KEY_ONLY, VALUE_ONLY, or KEY_AND_VALUE."
  }
}

variable "ecs_service" {
  description = "Configuration blocks of the ECS services for a deployment group."
  type = list(object({
    cluster_name = string
    service_name = string
  }))
  default = null

  validation {
    condition = var.ecs_service == null || alltrue([
      for service in var.ecs_service :
      length(service.cluster_name) > 0 && length(service.service_name) > 0
    ])
    error_message = "resource_aws_codedeploy_deployment_group, ecs_service.cluster_name and ecs_service.service_name cannot be empty."
  }
}

variable "load_balancer_info" {
  description = "Single configuration block of the load balancer to use in a blue/green deployment."
  type = object({
    elb_info = optional(list(object({
      name = optional(string)
    })))
    target_group_info = optional(list(object({
      name = optional(string)
    })))
    target_group_pair_info = optional(object({
      prod_traffic_route = optional(object({
        listener_arns = list(string)
      }))
      target_group = optional(list(object({
        name = string
      })))
      test_traffic_route = optional(object({
        listener_arns = list(string)
      }))
    }))
  })
  default = null

  validation {
    condition = var.load_balancer_info == null || (
      var.load_balancer_info.target_group_pair_info == null ||
      var.load_balancer_info.target_group_pair_info.prod_traffic_route == null ||
      length(var.load_balancer_info.target_group_pair_info.prod_traffic_route.listener_arns) == 1
    )
    error_message = "resource_aws_codedeploy_deployment_group, load_balancer_info.target_group_pair_info.prod_traffic_route.listener_arns must contain exactly one listener ARN."
  }

  validation {
    condition = var.load_balancer_info == null || (
      var.load_balancer_info.target_group_pair_info == null ||
      var.load_balancer_info.target_group_pair_info.target_group == null ||
      alltrue([
        for tg in var.load_balancer_info.target_group_pair_info.target_group :
        length(tg.name) > 0
      ])
    )
    error_message = "resource_aws_codedeploy_deployment_group, load_balancer_info.target_group_pair_info.target_group.name cannot be empty."
  }
}

variable "on_premises_instance_tag_filter" {
  description = "On premise tag filters associated with the group."
  type = list(object({
    key   = optional(string)
    type  = optional(string)
    value = optional(string)
  }))
  default = null

  validation {
    condition = var.on_premises_instance_tag_filter == null || alltrue([
      for filter in var.on_premises_instance_tag_filter :
      filter.type == null || contains(["KEY_ONLY", "VALUE_ONLY", "KEY_AND_VALUE"], filter.type)
    ])
    error_message = "resource_aws_codedeploy_deployment_group, on_premises_instance_tag_filter.type must be KEY_ONLY, VALUE_ONLY, or KEY_AND_VALUE."
  }
}

variable "trigger_configuration" {
  description = "Configuration blocks of the triggers for the deployment group."
  type = list(object({
    trigger_events     = list(string)
    trigger_name       = string
    trigger_target_arn = string
  }))
  default = null

  validation {
    condition = var.trigger_configuration == null || alltrue([
      for config in var.trigger_configuration :
      length(config.trigger_name) > 0 && length(config.trigger_target_arn) > 0 && length(config.trigger_events) > 0
    ])
    error_message = "resource_aws_codedeploy_deployment_group, trigger_configuration.trigger_name, trigger_target_arn, and trigger_events cannot be empty."
  }

  validation {
    condition = var.trigger_configuration == null || alltrue([
      for config in var.trigger_configuration :
      can(regex("^arn:aws[a-zA-Z-]*:sns:[a-z0-9-]+:[0-9]{12}:.+", config.trigger_target_arn))
    ])
    error_message = "resource_aws_codedeploy_deployment_group, trigger_configuration.trigger_target_arn must be a valid SNS topic ARN."
  }

  validation {
    condition = var.trigger_configuration == null || alltrue([
      for config in var.trigger_configuration :
      alltrue([
        for event in config.trigger_events :
        contains(["DeploymentStart", "DeploymentSuccess", "DeploymentFailure", "DeploymentStop", "DeploymentRollback", "InstanceStart", "InstanceSuccess", "InstanceFailure"], event)
      ])
    ])
    error_message = "resource_aws_codedeploy_deployment_group, trigger_configuration.trigger_events must contain valid trigger events."
  }
}

variable "outdated_instances_strategy" {
  description = "Configuration block of Indicates what happens when new Amazon EC2 instances are launched mid-deployment and do not receive the deployed application revision. Valid values are UPDATE and IGNORE. Defaults to UPDATE."
  type        = string
  default     = "UPDATE"

  validation {
    condition     = contains(["UPDATE", "IGNORE"], var.outdated_instances_strategy)
    error_message = "resource_aws_codedeploy_deployment_group, outdated_instances_strategy must be UPDATE or IGNORE."
  }
}

variable "termination_hook_enabled" {
  description = "Indicates whether the deployment group was configured to have CodeDeploy install a termination hook into an Auto Scaling group."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}