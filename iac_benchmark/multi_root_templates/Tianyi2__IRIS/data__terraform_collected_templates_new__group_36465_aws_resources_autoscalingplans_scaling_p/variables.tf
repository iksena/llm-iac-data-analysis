variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the scaling plan. Names cannot contain vertical bars, colons, or forward slashes."
  type        = string

  validation {
    condition     = can(regex("^[^|:/*]*$", var.name))
    error_message = "resource_aws_autoscalingplans_scaling_plan, name cannot contain vertical bars, colons, or forward slashes."
  }
}

variable "application_source" {
  description = "CloudFormation stack or set of tags. You can create one scaling plan per application source."
  type = object({
    cloudformation_stack_arn = optional(string)
    tag_filter = optional(list(object({
      key    = string
      values = optional(list(string))
    })))
  })

  validation {
    condition = (
      var.application_source.cloudformation_stack_arn != null ||
      var.application_source.tag_filter != null
    )
    error_message = "resource_aws_autoscalingplans_scaling_plan, application_source must specify either cloudformation_stack_arn or tag_filter."
  }
}

variable "scaling_instruction" {
  description = "Scaling instructions."
  type = list(object({
    max_capacity       = number
    min_capacity       = number
    resource_id        = string
    scalable_dimension = string
    service_namespace  = string
    target_tracking_configuration = list(object({
      target_value = number
      customized_scaling_metric_specification = optional(object({
        metric_name = string
        namespace   = string
        statistic   = string
        dimensions  = optional(map(string))
        unit        = optional(string)
      }))
      disable_scale_in = optional(bool, false)
      predefined_scaling_metric_specification = optional(object({
        predefined_scaling_metric_type = string
        resource_label                 = optional(string)
      }))
      estimated_instance_warmup = optional(number)
      scale_in_cooldown         = optional(number)
      scale_out_cooldown        = optional(number)
    }))
    customized_load_metric_specification = optional(object({
      metric_name = string
      namespace   = string
      statistic   = string
      dimensions  = optional(map(string))
      unit        = optional(string)
    }))
    disable_dynamic_scaling = optional(bool, false)
    predefined_load_metric_specification = optional(object({
      predefined_load_metric_type = string
      resource_label              = optional(string)
    }))
    predictive_scaling_max_capacity_behavior = optional(string)
    predictive_scaling_max_capacity_buffer   = optional(number)
    predictive_scaling_mode                  = optional(string)
    scaling_policy_update_behavior           = optional(string, "KeepExternalPolicies")
    scheduled_action_buffer_time             = optional(number)
  }))

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      contains(["autoscaling:autoScalingGroup:DesiredCapacity", "dynamodb:index:ReadCapacityUnits", "dynamodb:index:WriteCapacityUnits", "dynamodb:table:ReadCapacityUnits", "dynamodb:table:WriteCapacityUnits", "ecs:service:DesiredCount", "ec2:spot-fleet-request:TargetCapacity", "rds:cluster:ReadReplicaCount"], instruction.scalable_dimension)
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, scalable_dimension must be one of: autoscaling:autoScalingGroup:DesiredCapacity, dynamodb:index:ReadCapacityUnits, dynamodb:index:WriteCapacityUnits, dynamodb:table:ReadCapacityUnits, dynamodb:table:WriteCapacityUnits, ecs:service:DesiredCount, ec2:spot-fleet-request:TargetCapacity, rds:cluster:ReadReplicaCount."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      contains(["autoscaling", "dynamodb", "ecs", "ec2", "rds"], instruction.service_namespace)
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, service_namespace must be one of: autoscaling, dynamodb, ecs, ec2, rds."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      alltrue([
        for config in instruction.target_tracking_configuration :
        config.customized_scaling_metric_specification != null || config.predefined_scaling_metric_specification != null
      ])
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, target_tracking_configuration must specify either customized_scaling_metric_specification or predefined_scaling_metric_specification."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      alltrue([
        for config in instruction.target_tracking_configuration :
        config.customized_scaling_metric_specification == null ? true : contains(["Average", "Maximum", "Minimum", "SampleCount", "Sum"], config.customized_scaling_metric_specification.statistic)
      ])
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, customized_scaling_metric_specification.statistic must be one of: Average, Maximum, Minimum, SampleCount, Sum."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      alltrue([
        for config in instruction.target_tracking_configuration :
        config.predefined_scaling_metric_specification == null ? true : contains(["ALBRequestCountPerTarget", "ASGAverageCPUUtilization", "ASGAverageNetworkIn", "ASGAverageNetworkOut", "DynamoDBReadCapacityUtilization", "DynamoDBWriteCapacityUtilization", "ECSServiceAverageCPUUtilization", "ECSServiceAverageMemoryUtilization", "EC2SpotFleetRequestAverageCPUUtilization", "EC2SpotFleetRequestAverageNetworkIn", "EC2SpotFleetRequestAverageNetworkOut", "RDSReaderAverageCPUUtilization", "RDSReaderAverageDatabaseConnections"], config.predefined_scaling_metric_specification.predefined_scaling_metric_type)
      ])
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, predefined_scaling_metric_specification.predefined_scaling_metric_type must be one of: ALBRequestCountPerTarget, ASGAverageCPUUtilization, ASGAverageNetworkIn, ASGAverageNetworkOut, DynamoDBReadCapacityUtilization, DynamoDBWriteCapacityUtilization, ECSServiceAverageCPUUtilization, ECSServiceAverageMemoryUtilization, EC2SpotFleetRequestAverageCPUUtilization, EC2SpotFleetRequestAverageNetworkIn, EC2SpotFleetRequestAverageNetworkOut, RDSReaderAverageCPUUtilization, RDSReaderAverageDatabaseConnections."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      instruction.customized_load_metric_specification == null ? true : instruction.customized_load_metric_specification.statistic == "Sum"
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, customized_load_metric_specification.statistic must be Sum."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      instruction.predefined_load_metric_specification == null ? true : contains(["ALBTargetGroupRequestCount", "ASGTotalCPUUtilization", "ASGTotalNetworkIn", "ASGTotalNetworkOut"], instruction.predefined_load_metric_specification.predefined_load_metric_type)
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, predefined_load_metric_specification.predefined_load_metric_type must be one of: ALBTargetGroupRequestCount, ASGTotalCPUUtilization, ASGTotalNetworkIn, ASGTotalNetworkOut."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      instruction.predictive_scaling_max_capacity_behavior == null ? true : contains(["SetForecastCapacityToMaxCapacity", "SetMaxCapacityAboveForecastCapacity", "SetMaxCapacityToForecastCapacity"], instruction.predictive_scaling_max_capacity_behavior)
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, predictive_scaling_max_capacity_behavior must be one of: SetForecastCapacityToMaxCapacity, SetMaxCapacityAboveForecastCapacity, SetMaxCapacityToForecastCapacity."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      instruction.predictive_scaling_mode == null ? true : contains(["ForecastAndScale", "ForecastOnly"], instruction.predictive_scaling_mode)
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, predictive_scaling_mode must be one of: ForecastAndScale, ForecastOnly."
  }

  validation {
    condition = alltrue([
      for instruction in var.scaling_instruction :
      instruction.scaling_policy_update_behavior == null ? true : contains(["KeepExternalPolicies", "ReplaceExternalPolicies"], instruction.scaling_policy_update_behavior)
    ])
    error_message = "resource_aws_autoscalingplans_scaling_plan, scaling_policy_update_behavior must be one of: KeepExternalPolicies, ReplaceExternalPolicies."
  }
}