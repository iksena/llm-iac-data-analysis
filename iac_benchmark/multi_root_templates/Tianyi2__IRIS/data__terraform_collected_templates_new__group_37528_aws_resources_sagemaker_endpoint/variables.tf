variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "endpoint_config_name" {
  description = "The name of the endpoint configuration to use."
  type        = string
  validation {
    condition     = length(var.endpoint_config_name) > 0
    error_message = "resource_aws_sagemaker_endpoint, endpoint_config_name cannot be empty."
  }
}

variable "deployment_config" {
  description = "The deployment configuration for an endpoint, which contains the desired deployment strategy and rollback configurations."
  type = object({
    blue_green_update_policy = optional(object({
      traffic_routing_configuration = object({
        type                     = string
        wait_interval_in_seconds = number
        canary_size = optional(object({
          type  = string
          value = number
        }))
        linear_step_size = optional(object({
          type  = string
          value = number
        }))
      })
      maximum_execution_timeout_in_seconds = optional(number)
      termination_wait_in_seconds          = optional(number)
    }))
    auto_rollback_configuration = optional(object({
      alarms = list(object({
        alarm_name = string
      }))
    }))
    rolling_update_policy = optional(object({
      maximum_batch_size = object({
        type  = string
        value = number
      })
      maximum_execution_timeout_in_seconds = optional(number)
      rollback_maximum_batch_size = optional(object({
        type  = string
        value = number
      }))
      wait_interval_in_seconds = number
    }))
  })
  default = null

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.blue_green_update_policy == null ? true :
      contains(["ALL_AT_ONCE", "CANARY", "LINEAR"], var.deployment_config.blue_green_update_policy.traffic_routing_configuration.type)
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.blue_green_update_policy.traffic_routing_configuration.type must be one of: ALL_AT_ONCE, CANARY, LINEAR."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.blue_green_update_policy == null ? true :
      var.deployment_config.blue_green_update_policy.traffic_routing_configuration.wait_interval_in_seconds >= 0 &&
      var.deployment_config.blue_green_update_policy.traffic_routing_configuration.wait_interval_in_seconds <= 3600
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.blue_green_update_policy.traffic_routing_configuration.wait_interval_in_seconds must be between 0 and 3600."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.blue_green_update_policy == null ? true :
      var.deployment_config.blue_green_update_policy.maximum_execution_timeout_in_seconds == null ? true :
      var.deployment_config.blue_green_update_policy.maximum_execution_timeout_in_seconds >= 600 &&
      var.deployment_config.blue_green_update_policy.maximum_execution_timeout_in_seconds <= 14400
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.blue_green_update_policy.maximum_execution_timeout_in_seconds must be between 600 and 14400."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.blue_green_update_policy == null ? true :
      var.deployment_config.blue_green_update_policy.termination_wait_in_seconds == null ? true :
      var.deployment_config.blue_green_update_policy.termination_wait_in_seconds >= 0 &&
      var.deployment_config.blue_green_update_policy.termination_wait_in_seconds <= 3600
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.blue_green_update_policy.termination_wait_in_seconds must be between 0 and 3600."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.blue_green_update_policy == null ? true :
      var.deployment_config.blue_green_update_policy.traffic_routing_configuration.canary_size == null ? true :
      contains(["INSTANCE_COUNT", "CAPACITY_PERCENT"], var.deployment_config.blue_green_update_policy.traffic_routing_configuration.canary_size.type)
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.blue_green_update_policy.traffic_routing_configuration.canary_size.type must be one of: INSTANCE_COUNT, CAPACITY_PERCENT."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.blue_green_update_policy == null ? true :
      var.deployment_config.blue_green_update_policy.traffic_routing_configuration.linear_step_size == null ? true :
      contains(["INSTANCE_COUNT", "CAPACITY_PERCENT"], var.deployment_config.blue_green_update_policy.traffic_routing_configuration.linear_step_size.type)
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.blue_green_update_policy.traffic_routing_configuration.linear_step_size.type must be one of: INSTANCE_COUNT, CAPACITY_PERCENT."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.rolling_update_policy == null ? true :
      contains(["INSTANCE_COUNT", "CAPACITY_PERCENT"], var.deployment_config.rolling_update_policy.maximum_batch_size.type)
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.rolling_update_policy.maximum_batch_size.type must be one of: INSTANCE_COUNT, CAPACITY_PERCENT."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.rolling_update_policy == null ? true :
      var.deployment_config.rolling_update_policy.maximum_execution_timeout_in_seconds == null ? true :
      var.deployment_config.rolling_update_policy.maximum_execution_timeout_in_seconds >= 600 &&
      var.deployment_config.rolling_update_policy.maximum_execution_timeout_in_seconds <= 14400
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.rolling_update_policy.maximum_execution_timeout_in_seconds must be between 600 and 14400."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.rolling_update_policy == null ? true :
      var.deployment_config.rolling_update_policy.rollback_maximum_batch_size == null ? true :
      contains(["INSTANCE_COUNT", "CAPACITY_PERCENT"], var.deployment_config.rolling_update_policy.rollback_maximum_batch_size.type)
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.rolling_update_policy.rollback_maximum_batch_size.type must be one of: INSTANCE_COUNT, CAPACITY_PERCENT."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.rolling_update_policy == null ? true :
      var.deployment_config.rolling_update_policy.wait_interval_in_seconds >= 0 &&
      var.deployment_config.rolling_update_policy.wait_interval_in_seconds <= 3600
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.rolling_update_policy.wait_interval_in_seconds must be between 0 and 3600."
  }

  validation {
    condition = var.deployment_config == null ? true : (
      var.deployment_config.auto_rollback_configuration == null ? true :
      length(var.deployment_config.auto_rollback_configuration.alarms) > 0
    )
    error_message = "resource_aws_sagemaker_endpoint, deployment_config.auto_rollback_configuration.alarms must contain at least one alarm."
  }
}

variable "name" {
  description = "The name of the endpoint. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}