variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "context" {
  description = "Reserved."
  type        = string
  default     = null
}

variable "excess_capacity_termination_policy" {
  description = "Whether running instances should be terminated if the total target capacity of the EC2 Fleet is decreased below the current size of the EC2. Valid values: no-termination, termination. Defaults to termination. Supported only for fleets of type maintain."
  type        = string
  default     = "termination"

  validation {
    condition     = var.excess_capacity_termination_policy == null || contains(["no-termination", "termination"], var.excess_capacity_termination_policy)
    error_message = "resource_aws_ec2_fleet, excess_capacity_termination_policy must be one of: no-termination, termination."
  }
}

variable "launch_template_config" {
  description = "Nested argument containing EC2 Launch Template configurations."
  type = list(object({
    launch_template_specification = optional(object({
      launch_template_id   = optional(string)
      launch_template_name = optional(string)
      version              = string
    }))
    override = optional(list(object({
      availability_zone = optional(string)
      instance_type     = optional(string)
      max_price         = optional(string)
      priority          = optional(number)
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
        burstable_performance                                   = optional(string)
        cpu_manufacturers                                       = optional(list(string))
        excluded_instance_types                                 = optional(list(string))
        instance_generations                                    = optional(list(string))
        local_storage                                           = optional(string)
        local_storage_types                                     = optional(list(string))
        max_spot_price_as_percentage_of_optimal_on_demand_price = optional(number)
        memory_gib_per_vcpu = optional(object({
          min = optional(number)
          max = optional(number)
        }))
        memory_mib = optional(object({
          min = number
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
          min = number
          max = optional(number)
        }))
      }))
    })))
  }))

  validation {
    condition     = length(var.launch_template_config) > 0
    error_message = "resource_aws_ec2_fleet, launch_template_config is required and must contain at least one element."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.launch_template_specification != null ? (
        config.launch_template_specification.launch_template_id != null ||
        config.launch_template_specification.launch_template_name != null
      ) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config launch_template_specification must specify either launch_template_id or launch_template_name."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? (
        length(config.override) <= 300
      ) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override maximum of 300 items is allowed across all launch templates for fleets of type request and maintain."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.bare_metal == null ||
          contains(["included", "excluded", "required"], override.instance_requirements.bare_metal)
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements bare_metal must be one of: included, excluded, required."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.burstable_performance == null ||
          contains(["included", "excluded", "required"], override.instance_requirements.burstable_performance)
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements burstable_performance must be one of: included, excluded, required."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.local_storage == null ||
          contains(["included", "excluded", "required"], override.instance_requirements.local_storage)
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements local_storage must be one of: included, excluded, required."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.local_storage_types == null ||
          alltrue([for type in override.instance_requirements.local_storage_types : contains(["hdd", "ssd"], type)])
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements local_storage_types must contain only: hdd, ssd."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.instance_generations == null ||
          alltrue([for gen in override.instance_requirements.instance_generations : contains(["current", "previous"], gen)])
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements instance_generations must contain only: current, previous."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.allowed_instance_types == null ||
          length(override.instance_requirements.allowed_instance_types) <= 400
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements allowed_instance_types maximum of 400 entries allowed."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          override.instance_requirements.excluded_instance_types == null ||
          length(override.instance_requirements.excluded_instance_types) <= 400
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements excluded_instance_types maximum of 400 entries allowed."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          !(override.instance_requirements.allowed_instance_types != null && override.instance_requirements.excluded_instance_types != null)
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements cannot specify both allowed_instance_types and excluded_instance_types."
  }

  validation {
    condition = alltrue([
      for config in var.launch_template_config :
      config.override != null ? alltrue([
        for override in config.override :
        override.instance_requirements != null ? (
          !(override.instance_requirements.max_spot_price_as_percentage_of_optimal_on_demand_price != null && override.instance_requirements.spot_max_price_percentage_over_lowest_price != null)
        ) : true
      ]) : true
    ])
    error_message = "resource_aws_ec2_fleet, launch_template_config override instance_requirements max_spot_price_as_percentage_of_optimal_on_demand_price conflicts with spot_max_price_percentage_over_lowest_price."
  }
}

variable "on_demand_options" {
  description = "Nested argument containing On-Demand configurations."
  type = object({
    allocation_strategy = optional(string)
    capacity_reservation_options = optional(object({
      usage_strategy = optional(string)
    }))
    max_total_price          = optional(string)
    min_target_capacity      = optional(number)
    single_availability_zone = optional(bool)
    single_instance_type     = optional(bool)
  })
  default = null

  validation {
    condition     = var.on_demand_options == null || var.on_demand_options.allocation_strategy == null || contains(["lowestPrice", "prioritized"], var.on_demand_options.allocation_strategy)
    error_message = "resource_aws_ec2_fleet, on_demand_options allocation_strategy must be one of: lowestPrice, prioritized."
  }

  validation {
    condition     = var.on_demand_options == null || var.on_demand_options.capacity_reservation_options == null || var.on_demand_options.capacity_reservation_options.usage_strategy == null || var.on_demand_options.capacity_reservation_options.usage_strategy == "use-capacity-reservations-first"
    error_message = "resource_aws_ec2_fleet, on_demand_options capacity_reservation_options usage_strategy must be: use-capacity-reservations-first."
  }
}

variable "replace_unhealthy_instances" {
  description = "Whether EC2 Fleet should replace unhealthy instances. Defaults to false. Supported only for fleets of type maintain."
  type        = bool
  default     = false
}

variable "spot_options" {
  description = "Nested argument containing Spot configurations."
  type = object({
    allocation_strategy            = optional(string)
    instance_interruption_behavior = optional(string)
    instance_pools_to_use_count    = optional(number)
    maintenance_strategies = optional(object({
      capacity_rebalance = optional(object({
        replacement_strategy = optional(string)
      }))
    }))
    max_total_price          = optional(string)
    min_target_capacity      = optional(number)
    single_availability_zone = optional(bool)
    single_instance_type     = optional(bool)
  })
  default = null

  validation {
    condition     = var.spot_options == null || var.spot_options.allocation_strategy == null || contains(["diversified", "lowestPrice", "capacity-optimized", "capacity-optimized-prioritized", "price-capacity-optimized"], var.spot_options.allocation_strategy)
    error_message = "resource_aws_ec2_fleet, spot_options allocation_strategy must be one of: diversified, lowestPrice, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized."
  }

  validation {
    condition     = var.spot_options == null || var.spot_options.instance_interruption_behavior == null || contains(["hibernate", "stop", "terminate"], var.spot_options.instance_interruption_behavior)
    error_message = "resource_aws_ec2_fleet, spot_options instance_interruption_behavior must be one of: hibernate, stop, terminate."
  }

  validation {
    condition     = var.spot_options == null || var.spot_options.maintenance_strategies == null || var.spot_options.maintenance_strategies.capacity_rebalance == null || var.spot_options.maintenance_strategies.capacity_rebalance.replacement_strategy == null || var.spot_options.maintenance_strategies.capacity_rebalance.replacement_strategy == "launch"
    error_message = "resource_aws_ec2_fleet, spot_options maintenance_strategies capacity_rebalance replacement_strategy must be: launch."
  }
}

variable "tags" {
  description = "Map of Fleet tags. To tag instances at launch, specify the tags in the Launch Template."
  type        = map(string)
  default     = {}
}

variable "target_capacity_specification" {
  description = "Nested argument containing target capacity configurations."
  type = object({
    default_target_capacity_type = string
    on_demand_target_capacity    = optional(number)
    spot_target_capacity         = optional(number)
    target_capacity_unit_type    = optional(string)
    total_target_capacity        = number
  })

  validation {
    condition     = contains(["on-demand", "spot"], var.target_capacity_specification.default_target_capacity_type)
    error_message = "resource_aws_ec2_fleet, target_capacity_specification default_target_capacity_type must be one of: on-demand, spot."
  }
}

variable "terminate_instances" {
  description = "Whether to terminate instances for an EC2 Fleet if it is deleted successfully. Defaults to false."
  type        = bool
  default     = false
}

variable "terminate_instances_with_expiration" {
  description = "Whether running instances should be terminated when the EC2 Fleet expires. Defaults to false."
  type        = bool
  default     = false
}

variable "type" {
  description = "The type of request. Indicates whether the EC2 Fleet only requests the target capacity, or also attempts to maintain it. Valid values: maintain, request, instant. Defaults to maintain."
  type        = string
  default     = "maintain"

  validation {
    condition     = contains(["maintain", "request", "instant"], var.type)
    error_message = "resource_aws_ec2_fleet, type must be one of: maintain, request, instant."
  }
}

variable "valid_from" {
  description = "The start date and time of the request, in UTC format (for example, YYYY-MM-DDTHH:MM:SSZ). The default is to start fulfilling the request immediately."
  type        = string
  default     = null
}

variable "valid_until" {
  description = "The end date and time of the request, in UTC format (for example, YYYY-MM-DDTHH:MM:SSZ). At this point, no new EC2 Fleet requests are placed or able to fulfill the request."
  type        = string
  default     = null
}