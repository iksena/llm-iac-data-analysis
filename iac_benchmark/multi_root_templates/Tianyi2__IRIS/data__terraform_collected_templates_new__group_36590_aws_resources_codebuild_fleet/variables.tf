variable "name" {
  description = "Fleet name"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codebuild_fleet, name must be a non-empty string."
  }
}

variable "base_capacity" {
  description = "Number of machines allocated to the fleet"
  type        = number

  validation {
    condition     = var.base_capacity > 0
    error_message = "resource_aws_codebuild_fleet, base_capacity must be greater than 0."
  }
}

variable "compute_type" {
  description = "Compute resources the compute fleet uses"
  type        = string

  validation {
    condition = contains([
      "BUILD_GENERAL1_SMALL",
      "BUILD_GENERAL1_MEDIUM",
      "BUILD_GENERAL1_LARGE",
      "BUILD_GENERAL1_2XLARGE",
      "BUILD_LAMBDA_1GB",
      "BUILD_LAMBDA_2GB",
      "BUILD_LAMBDA_4GB",
      "BUILD_LAMBDA_8GB",
      "BUILD_LAMBDA_10GB",
      "ATTRIBUTE_BASED_COMPUTE",
      "CUSTOM_INSTANCE_TYPE"
    ], var.compute_type)
    error_message = "resource_aws_codebuild_fleet, compute_type must be a valid compute type."
  }
}

variable "environment_type" {
  description = "Environment type of the compute fleet"
  type        = string

  validation {
    condition = contains([
      "LINUX_CONTAINER",
      "LINUX_GPU_CONTAINER",
      "WINDOWS_CONTAINER",
      "WINDOWS_SERVER_2019_CONTAINER",
      "WINDOWS_SERVER_2022_CONTAINER"
    ], var.environment_type)
    error_message = "resource_aws_codebuild_fleet, environment_type must be a valid environment type."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "compute_configuration" {
  description = "The compute configuration of the compute fleet"
  type = object({
    disk          = optional(number)
    instance_type = optional(string)
    machine_type  = optional(string)
    memory        = optional(number)
    vcpu          = optional(number)
  })
  default = null

  validation {
    condition = var.compute_configuration == null || (
      var.compute_configuration.machine_type == null || contains(["GENERAL", "NVME"], var.compute_configuration.machine_type)
    )
    error_message = "resource_aws_codebuild_fleet, compute_configuration.machine_type must be either GENERAL or NVME."
  }
}

variable "fleet_service_role" {
  description = "The service role associated with the compute fleet"
  type        = string
  default     = null
}

variable "image_id" {
  description = "The Amazon Machine Image (AMI) of the compute fleet"
  type        = string
  default     = null
}

variable "overflow_behavior" {
  description = "Overflow behavior for compute fleet"
  type        = string
  default     = null

  validation {
    condition     = var.overflow_behavior == null || contains(["ON_DEMAND", "QUEUE"], var.overflow_behavior)
    error_message = "resource_aws_codebuild_fleet, overflow_behavior must be either ON_DEMAND or QUEUE."
  }
}

variable "scaling_configuration" {
  description = "Configuration for scaling"
  type = object({
    max_capacity = optional(number)
    scaling_type = optional(string)
    target_tracking_scaling_configs = optional(object({
      metric_type  = optional(string)
      target_value = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.scaling_configuration == null || (
      var.scaling_configuration.scaling_type == null || var.scaling_configuration.scaling_type == "TARGET_TRACKING_SCALING"
    )
    error_message = "resource_aws_codebuild_fleet, scaling_configuration.scaling_type must be TARGET_TRACKING_SCALING."
  }

  validation {
    condition = var.scaling_configuration == null || (
      var.scaling_configuration.target_tracking_scaling_configs == null ||
      var.scaling_configuration.target_tracking_scaling_configs.metric_type == null ||
      var.scaling_configuration.target_tracking_scaling_configs.metric_type == "FLEET_UTILIZATION_RATE"
    )
    error_message = "resource_aws_codebuild_fleet, scaling_configuration.target_tracking_scaling_configs.metric_type must be FLEET_UTILIZATION_RATE."
  }

  validation {
    condition = var.scaling_configuration == null || (
      var.scaling_configuration.max_capacity == null || var.scaling_configuration.max_capacity > 0
    )
    error_message = "resource_aws_codebuild_fleet, scaling_configuration.max_capacity must be greater than 0."
  }

  validation {
    condition = var.scaling_configuration == null || (
      var.scaling_configuration.target_tracking_scaling_configs == null ||
      var.scaling_configuration.target_tracking_scaling_configs.target_value == null ||
      (var.scaling_configuration.target_tracking_scaling_configs.target_value >= 0 && var.scaling_configuration.target_tracking_scaling_configs.target_value <= 100)
    )
    error_message = "resource_aws_codebuild_fleet, scaling_configuration.target_tracking_scaling_configs.target_value must be between 0 and 100."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "Configuration for VPC"
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
    vpc_id             = string
  })
  default = null

  validation {
    condition = var.vpc_config == null || (
      length(var.vpc_config.security_group_ids) > 0 &&
      length(var.vpc_config.subnets) > 0 &&
      length(var.vpc_config.vpc_id) > 0
    )
    error_message = "resource_aws_codebuild_fleet, vpc_config requires non-empty security_group_ids, subnets, and vpc_id."
  }
}