variable "cluster_id" {
  description = "ID of the EMR Cluster to attach to. Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = can(regex("^j-[0-9A-Z]+$", var.cluster_id))
    error_message = "resource_aws_emr_instance_fleet, cluster_id must be a valid EMR cluster ID starting with 'j-'."
  }
}

variable "name" {
  description = "Friendly name given to the instance fleet."
  type        = string
  default     = null
}

variable "target_on_demand_capacity" {
  description = "The target capacity of On-Demand units for the instance fleet, which determines how many On-Demand instances to provision."
  type        = number
  default     = null

  validation {
    condition     = var.target_on_demand_capacity == null || var.target_on_demand_capacity >= 0
    error_message = "resource_aws_emr_instance_fleet, target_on_demand_capacity must be a non-negative number."
  }
}

variable "target_spot_capacity" {
  description = "The target capacity of Spot units for the instance fleet, which determines how many Spot instances to provision."
  type        = number
  default     = null

  validation {
    condition     = var.target_spot_capacity == null || var.target_spot_capacity >= 0
    error_message = "resource_aws_emr_instance_fleet, target_spot_capacity must be a non-negative number."
  }
}

variable "instance_type_configs" {
  description = "Configuration block for instance fleet"
  type = list(object({
    instance_type                              = string
    bid_price                                  = optional(string)
    bid_price_as_percentage_of_on_demand_price = optional(number)
    weighted_capacity                          = optional(number)
    configurations = optional(list(object({
      classification = optional(string)
      properties     = optional(map(string))
    })))
    ebs_config = optional(list(object({
      size                 = number
      type                 = string
      iops                 = optional(number)
      volumes_per_instance = optional(number)
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.instance_type_configs : can(regex("^[a-z][0-9][a-z]?\\.[a-z0-9]+$", config.instance_type))
    ])
    error_message = "resource_aws_emr_instance_fleet, instance_type must be a valid EC2 instance type (e.g., m4.xlarge)."
  }

  validation {
    condition = alltrue([
      for config in var.instance_type_configs :
      config.bid_price_as_percentage_of_on_demand_price == null ||
      (config.bid_price_as_percentage_of_on_demand_price >= 0 && config.bid_price_as_percentage_of_on_demand_price <= 1000)
    ])
    error_message = "resource_aws_emr_instance_fleet, bid_price_as_percentage_of_on_demand_price must be between 0 and 1000."
  }

  validation {
    condition = alltrue([
      for config in var.instance_type_configs :
      config.weighted_capacity == null || config.weighted_capacity > 0
    ])
    error_message = "resource_aws_emr_instance_fleet, weighted_capacity must be a positive number."
  }

  validation {
    condition = alltrue([
      for config in var.instance_type_configs :
      config.ebs_config == null || alltrue([
        for ebs in config.ebs_config :
        ebs.size > 0
      ])
    ])
    error_message = "resource_aws_emr_instance_fleet, ebs_config size must be greater than 0."
  }

  validation {
    condition = alltrue([
      for config in var.instance_type_configs :
      config.ebs_config == null || alltrue([
        for ebs in config.ebs_config :
        contains(["gp2", "io1", "standard", "st1"], ebs.type)
      ])
    ])
    error_message = "resource_aws_emr_instance_fleet, ebs_config type must be one of: gp2, io1, standard, st1."
  }

  validation {
    condition = alltrue([
      for config in var.instance_type_configs :
      config.ebs_config == null || alltrue([
        for ebs in config.ebs_config :
        ebs.volumes_per_instance == null || ebs.volumes_per_instance >= 1
      ])
    ])
    error_message = "resource_aws_emr_instance_fleet, ebs_config volumes_per_instance must be at least 1."
  }
}

variable "launch_specifications" {
  description = "Configuration block for launch specification"
  type = object({
    on_demand_specification = optional(object({
      allocation_strategy = string
    }))
    spot_specification = optional(object({
      allocation_strategy      = string
      block_duration_minutes   = optional(number)
      timeout_action           = string
      timeout_duration_minutes = number
    }))
  })
  default = null

  validation {
    condition     = var.launch_specifications == null || var.launch_specifications.on_demand_specification == null || contains(["lowest-price"], var.launch_specifications.on_demand_specification.allocation_strategy)
    error_message = "resource_aws_emr_instance_fleet, on_demand_specification allocation_strategy must be 'lowest-price'."
  }

  validation {
    condition     = var.launch_specifications == null || var.launch_specifications.spot_specification == null || contains(["price-capacity-optimized", "capacity-optimized", "lowest-price", "diversified"], var.launch_specifications.spot_specification.allocation_strategy)
    error_message = "resource_aws_emr_instance_fleet, spot_specification allocation_strategy must be one of: price-capacity-optimized, capacity-optimized, lowest-price, diversified."
  }

  validation {
    condition     = var.launch_specifications == null || var.launch_specifications.spot_specification == null || var.launch_specifications.spot_specification.block_duration_minutes == null || contains([60, 120, 180, 240, 300, 360], var.launch_specifications.spot_specification.block_duration_minutes)
    error_message = "resource_aws_emr_instance_fleet, spot_specification block_duration_minutes must be one of: 60, 120, 180, 240, 300, 360."
  }

  validation {
    condition     = var.launch_specifications == null || var.launch_specifications.spot_specification == null || contains(["TERMINATE_CLUSTER", "SWITCH_TO_ON_DEMAND"], var.launch_specifications.spot_specification.timeout_action)
    error_message = "resource_aws_emr_instance_fleet, spot_specification timeout_action must be one of: TERMINATE_CLUSTER, SWITCH_TO_ON_DEMAND."
  }

  validation {
    condition     = var.launch_specifications == null || var.launch_specifications.spot_specification == null || (var.launch_specifications.spot_specification.timeout_duration_minutes >= 5 && var.launch_specifications.spot_specification.timeout_duration_minutes <= 1440)
    error_message = "resource_aws_emr_instance_fleet, spot_specification timeout_duration_minutes must be between 5 and 1440."
  }
}