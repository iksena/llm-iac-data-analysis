variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "iam_fleet_role" {
  description = "Grants the Spot fleet permission to terminate Spot instances on your behalf when you cancel its Spot fleet request using CancelSpotFleetRequests or when the Spot fleet request expires, if you set terminateInstancesWithExpiration."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.iam_fleet_role))
    error_message = "resource_aws_spot_fleet_request, iam_fleet_role must be a valid IAM role ARN."
  }
}

variable "context" {
  description = "Reserved."
  type        = string
  default     = null
}

variable "replace_unhealthy_instances" {
  description = "Indicates whether Spot fleet should replace unhealthy instances."
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "The maximum bid price per unit hour."
  type        = string
  default     = null

  validation {
    condition     = var.spot_price == null || can(regex("^[0-9]+(\\.[0-9]+)?$", var.spot_price))
    error_message = "resource_aws_spot_fleet_request, spot_price must be a valid decimal number."
  }
}

variable "wait_for_fulfillment" {
  description = "If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached."
  type        = bool
  default     = false
}

variable "target_capacity" {
  description = "The number of units to request. You can choose to set the target capacity in terms of instances or a performance characteristic that is important to your application workload, such as vCPUs, memory, or I/O."
  type        = number

  validation {
    condition     = var.target_capacity > 0
    error_message = "resource_aws_spot_fleet_request, target_capacity must be a positive number."
  }
}

variable "target_capacity_unit_type" {
  description = "The unit for the target capacity. This can only be done with instance_requirements defined."
  type        = string
  default     = null

  validation {
    condition     = var.target_capacity_unit_type == null || contains(["vcpu", "memory-mib", "units"], var.target_capacity_unit_type)
    error_message = "resource_aws_spot_fleet_request, target_capacity_unit_type must be one of: vcpu, memory-mib, units."
  }
}

variable "allocation_strategy" {
  description = "Indicates how to allocate the target capacity across the Spot pools specified by the Spot fleet request."
  type        = string
  default     = "lowestPrice"

  validation {
    condition     = contains(["lowestPrice", "diversified", "capacityOptimized", "capacityOptimizedPrioritized", "priceCapacityOptimized"], var.allocation_strategy)
    error_message = "resource_aws_spot_fleet_request, allocation_strategy must be one of: lowestPrice, diversified, capacityOptimized, capacityOptimizedPrioritized, priceCapacityOptimized."
  }
}

variable "instance_pools_to_use_count" {
  description = "The number of Spot pools across which to allocate your target Spot capacity. Valid only when allocation_strategy is set to lowestPrice."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_pools_to_use_count > 0
    error_message = "resource_aws_spot_fleet_request, instance_pools_to_use_count must be a positive number."
  }
}

variable "excess_capacity_termination_policy" {
  description = "Indicates whether running Spot instances should be terminated if the target capacity of the Spot fleet request is decreased below the current size of the Spot fleet."
  type        = string
  default     = null

  validation {
    condition     = var.excess_capacity_termination_policy == null || contains(["noTermination", "default"], var.excess_capacity_termination_policy)
    error_message = "resource_aws_spot_fleet_request, excess_capacity_termination_policy must be one of: noTermination, default."
  }
}

variable "terminate_instances_with_expiration" {
  description = "Indicates whether running Spot instances should be terminated when the Spot fleet request expires."
  type        = bool
  default     = null
}

variable "terminate_instances_on_delete" {
  description = "Indicates whether running Spot instances should be terminated when the resource is deleted (and the Spot fleet request cancelled)."
  type        = bool
  default     = null
}

variable "instance_interruption_behaviour" {
  description = "Indicates whether a Spot instance stops or terminates when it is interrupted."
  type        = string
  default     = "terminate"

  validation {
    condition     = contains(["hibernate", "stop", "terminate"], var.instance_interruption_behaviour)
    error_message = "resource_aws_spot_fleet_request, instance_interruption_behaviour must be one of: hibernate, stop, terminate."
  }
}

variable "fleet_type" {
  description = "The type of fleet request. Indicates whether the Spot Fleet only requests the target capacity or also attempts to maintain it."
  type        = string
  default     = "maintain"

  validation {
    condition     = contains(["request", "maintain"], var.fleet_type)
    error_message = "resource_aws_spot_fleet_request, fleet_type must be one of: request, maintain."
  }
}

variable "valid_until" {
  description = "The end date and time of the request, in UTC RFC3339 format (for example, YYYY-MM-DDTHH:MM:SSZ)."
  type        = string
  default     = null

  validation {
    condition     = var.valid_until == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", var.valid_until))
    error_message = "resource_aws_spot_fleet_request, valid_until must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "valid_from" {
  description = "The start date and time of the request, in UTC RFC3339 format (for example, YYYY-MM-DDTHH:MM:SSZ)."
  type        = string
  default     = null

  validation {
    condition     = var.valid_from == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", var.valid_from))
    error_message = "resource_aws_spot_fleet_request, valid_from must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the Spot fleet."
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.target_group_arns : can(regex("^arn:aws:elasticloadbalancing:", arn))
    ])
    error_message = "resource_aws_spot_fleet_request, target_group_arns must be valid ELB target group ARNs."
  }
}

variable "on_demand_allocation_strategy" {
  description = "The order of the launch template overrides to use in fulfilling On-Demand capacity."
  type        = string
  default     = "lowestPrice"

  validation {
    condition     = contains(["lowestPrice", "prioritized"], var.on_demand_allocation_strategy)
    error_message = "resource_aws_spot_fleet_request, on_demand_allocation_strategy must be one of: lowestPrice, prioritized."
  }
}

variable "on_demand_max_total_price" {
  description = "The maximum amount per hour for On-Demand Instances that you're willing to pay."
  type        = string
  default     = null

  validation {
    condition     = var.on_demand_max_total_price == null || can(regex("^[0-9]+(\\.[0-9]+)?$", var.on_demand_max_total_price))
    error_message = "resource_aws_spot_fleet_request, on_demand_max_total_price must be a valid decimal number."
  }
}

variable "on_demand_target_capacity" {
  description = "The number of On-Demand units to request."
  type        = number
  default     = null

  validation {
    condition     = var.on_demand_target_capacity == null || var.on_demand_target_capacity >= 0
    error_message = "resource_aws_spot_fleet_request, on_demand_target_capacity must be a non-negative number."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "launch_specification" {
  description = "Used to define the launch configuration of the spot-fleet request. Can be specified multiple times to define different bids across different markets and instance types."
  type = list(object({
    ami               = string
    availability_zone = optional(string)
    ebs_block_device = optional(list(object({
      delete_on_termination = optional(bool)
      device_name           = string
      encrypted             = optional(bool)
      iops                  = optional(number)
      kms_key_id            = optional(string)
      snapshot_id           = optional(string)
      throughput            = optional(number)
      volume_size           = optional(number)
      volume_type           = optional(string)
    })))
    ebs_optimized = optional(bool)
    ephemeral_block_device = optional(list(object({
      device_name  = string
      virtual_name = string
    })))
    iam_instance_profile     = optional(string)
    iam_instance_profile_arn = optional(string)
    instance_type            = string
    key_name                 = optional(string)
    monitoring               = optional(bool)
    placement_group          = optional(string)
    placement_tenancy        = optional(string)
    root_block_device = optional(list(object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      iops                  = optional(number)
      kms_key_id            = optional(string)
      throughput            = optional(number)
      volume_size           = optional(number)
      volume_type           = optional(string)
    })))
    security_groups        = optional(list(string))
    spot_price             = optional(string)
    subnet_id              = optional(string)
    tags                   = optional(map(string))
    user_data              = optional(string)
    vpc_security_group_ids = optional(list(string))
    weighted_capacity      = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for spec in var.launch_specification : spec.placement_tenancy == null || contains(["default", "dedicated", "host"], spec.placement_tenancy)
    ])
    error_message = "resource_aws_spot_fleet_request, launch_specification placement_tenancy must be one of: default, dedicated, host."
  }

  validation {
    condition = alltrue([
      for spec in var.launch_specification : spec.spot_price == null || can(regex("^[0-9]+(\\.[0-9]+)?$", spec.spot_price))
    ])
    error_message = "resource_aws_spot_fleet_request, launch_specification spot_price must be a valid decimal number."
  }

  validation {
    condition = alltrue([
      for spec in var.launch_specification : spec.weighted_capacity == null || spec.weighted_capacity > 0
    ])
    error_message = "resource_aws_spot_fleet_request, launch_specification weighted_capacity must be a positive number."
  }
}

variable "launch_template_config" {
  description = "Launch template configuration block."
  type = list(object({
    launch_template_specification = object({
      id      = optional(string)
      name    = optional(string)
      version = optional(string)
    })
    overrides = optional(list(object({
      availability_zone = optional(string)
      instance_type     = optional(string)
      priority          = optional(number)
      spot_price        = optional(string)
      subnet_id         = optional(string)
      weighted_capacity = optional(number)
      instance_requirements = optional(object({
        accelerator_count = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        accelerator_manufacturers = optional(list(string))
        accelerator_names         = optional(list(string))
        accelerator_total_memory_mib = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        accelerator_types      = optional(list(string))
        allowed_instance_types = optional(list(string))
        bare_metal             = optional(string)
        baseline_ebs_bandwidth_mbps = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        burstable_performance   = optional(string)
        cpu_manufacturers       = optional(list(string))
        excluded_instance_types = optional(list(string))
        instance_generations    = optional(list(string))
        local_storage           = optional(string)
        local_storage_types     = optional(list(string))
        memory_gib_per_vcpu = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        memory_mib = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        network_bandwidth_gbps = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        network_interface_count = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        on_demand_max_price_percentage_over_lowest_price = optional(number)
        require_hibernate_support                        = optional(bool)
        spot_max_price_percentage_over_lowest_price      = optional(number)
        total_local_storage_gb = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        vcpu_count = optional(object({
          min = optional(number)
          max = optional(number)
        }))
      }))
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      (config.launch_template_specification.id != null && config.launch_template_specification.name == null) ||
      (config.launch_template_specification.id == null && config.launch_template_specification.name != null)
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config must specify either id or name, but not both."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.spot_price == null || can(regex("^[0-9]+(\\.[0-9]+)?$", override.spot_price))
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config override spot_price must be a valid decimal number."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.weighted_capacity == null || override.weighted_capacity > 0
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config override weighted_capacity must be a positive number."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.bare_metal == null || contains(["included", "excluded", "required"], override.instance_requirements.bare_metal)
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements bare_metal must be one of: included, excluded, required."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.burstable_performance == null || contains(["included", "excluded", "required"], override.instance_requirements.burstable_performance)
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements burstable_performance must be one of: included, excluded, required."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.local_storage == null || contains(["included", "excluded", "required"], override.instance_requirements.local_storage)
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements local_storage must be one of: included, excluded, required."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.accelerator_manufacturers == null || alltrue([
          for manufacturer in override.instance_requirements.accelerator_manufacturers :
          contains(["amazon-web-services", "amd", "nvidia", "xilinx"], manufacturer)
        ])
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements accelerator_manufacturers must be one of: amazon-web-services, amd, nvidia, xilinx."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.accelerator_names == null || alltrue([
          for name in override.instance_requirements.accelerator_names :
          contains(["a100", "v100", "k80", "t4", "m60", "radeon-pro-v520", "vu9p"], name)
        ])
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements accelerator_names must be one of: a100, v100, k80, t4, m60, radeon-pro-v520, vu9p."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.accelerator_types == null || alltrue([
          for type in override.instance_requirements.accelerator_types :
          contains(["fpga", "gpu", "inference"], type)
        ])
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements accelerator_types must be one of: fpga, gpu, inference."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.cpu_manufacturers == null || alltrue([
          for manufacturer in override.instance_requirements.cpu_manufacturers :
          contains(["amazon-web-services", "amd", "intel"], manufacturer)
        ])
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements cpu_manufacturers must be one of: amazon-web-services, amd, intel."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.instance_generations == null || alltrue([
          for generation in override.instance_requirements.instance_generations :
          contains(["current", "previous"], generation)
        ])
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements instance_generations must be one of: current, previous."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.overrides == null || alltrue([
        for override in config.overrides :
        override.instance_requirements == null || override.instance_requirements.local_storage_types == null || alltrue([
          for type in override.instance_requirements.local_storage_types :
          contains(["hdd", "ssd"], type)
        ])
      ])
    ])
    error_message = "resource_aws_spot_fleet_request, launch_template_config instance_requirements local_storage_types must be one of: hdd, ssd."
  }
}

variable "spot_maintenance_strategies" {
  description = "Nested argument containing maintenance strategies for managing your Spot Instances that are at an elevated risk of being interrupted."
  type = object({
    capacity_rebalance = optional(object({
      replacement_strategy = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.spot_maintenance_strategies == null || var.spot_maintenance_strategies.capacity_rebalance == null || var.spot_maintenance_strategies.capacity_rebalance.replacement_strategy == null || var.spot_maintenance_strategies.capacity_rebalance.replacement_strategy == "launch"
    error_message = "resource_aws_spot_fleet_request, spot_maintenance_strategies capacity_rebalance replacement_strategy must be 'launch'."
  }
}

variable "timeouts_create" {
  description = "Configuration option for create timeout."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_spot_fleet_request, timeouts_create must be in format like '10m', '60s', '1h'."
  }
}

variable "timeouts_delete" {
  description = "Configuration option for delete timeout."
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_spot_fleet_request, timeouts_delete must be in format like '15m', '60s', '1h'."
  }
}