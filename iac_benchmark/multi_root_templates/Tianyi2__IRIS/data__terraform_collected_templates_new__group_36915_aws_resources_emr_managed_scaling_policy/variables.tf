variable "cluster_id" {
  description = "ID of the EMR cluster"
  type        = string

  validation {
    condition     = can(regex("^j-[0-9A-Z]+$", var.cluster_id))
    error_message = "resource_aws_emr_managed_scaling_policy, cluster_id must be a valid EMR cluster ID starting with 'j-' followed by alphanumeric characters."
  }
}

variable "compute_limits" {
  description = "Configuration block with compute limit settings"
  type = object({
    unit_type                       = string
    minimum_capacity_units          = number
    maximum_capacity_units          = number
    maximum_ondemand_capacity_units = optional(number)
    maximum_core_capacity_units     = optional(number)
  })

  validation {
    condition     = contains(["InstanceFleetUnits", "Instances", "VCPU"], var.compute_limits.unit_type)
    error_message = "resource_aws_emr_managed_scaling_policy, unit_type must be one of: InstanceFleetUnits, Instances, VCPU."
  }

  validation {
    condition     = var.compute_limits.minimum_capacity_units > 0
    error_message = "resource_aws_emr_managed_scaling_policy, minimum_capacity_units must be greater than 0."
  }

  validation {
    condition     = var.compute_limits.maximum_capacity_units > 0
    error_message = "resource_aws_emr_managed_scaling_policy, maximum_capacity_units must be greater than 0."
  }

  validation {
    condition     = var.compute_limits.maximum_capacity_units >= var.compute_limits.minimum_capacity_units
    error_message = "resource_aws_emr_managed_scaling_policy, maximum_capacity_units must be greater than or equal to minimum_capacity_units."
  }

  validation {
    condition = var.compute_limits.maximum_ondemand_capacity_units == null || (
      var.compute_limits.maximum_ondemand_capacity_units > 0 &&
      var.compute_limits.maximum_ondemand_capacity_units <= var.compute_limits.maximum_capacity_units
    )
    error_message = "resource_aws_emr_managed_scaling_policy, maximum_ondemand_capacity_units must be greater than 0 and less than or equal to maximum_capacity_units when specified."
  }

  validation {
    condition = var.compute_limits.maximum_core_capacity_units == null || (
      var.compute_limits.maximum_core_capacity_units > 0 &&
      var.compute_limits.maximum_core_capacity_units <= var.compute_limits.maximum_capacity_units
    )
    error_message = "resource_aws_emr_managed_scaling_policy, maximum_core_capacity_units must be greater than 0 and less than or equal to maximum_capacity_units when specified."
  }
}