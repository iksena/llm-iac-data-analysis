variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Human friendly name given to the instance group. Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_emr_instance_group, name must not be empty."
  }
}

variable "cluster_id" {
  description = "ID of the EMR Cluster to attach to. Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = length(var.cluster_id) > 0
    error_message = "resource_aws_emr_instance_group, cluster_id must not be empty."
  }
}

variable "instance_type" {
  description = "The EC2 instance type for all instances in the instance group. Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = length(var.instance_type) > 0
    error_message = "resource_aws_emr_instance_group, instance_type must not be empty."
  }
}

variable "instance_count" {
  description = "Target number of instances for the instance group. Defaults to 0."
  type        = number
  default     = 0

  validation {
    condition     = var.instance_count >= 0
    error_message = "resource_aws_emr_instance_group, instance_count must be greater than or equal to 0."
  }
}

variable "bid_price" {
  description = "If set, the bid price for each EC2 instance in the instance group, expressed in USD. By setting this attribute, the instance group is being declared as a Spot Instance, and will implicitly create a Spot request. Leave this blank to use On-Demand Instances."
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "Indicates whether an Amazon EBS volume is EBS-optimized. Changing this forces a new resource to be created."
  type        = bool
  default     = null
}

variable "autoscaling_policy" {
  description = "The autoscaling policy document. This is a JSON formatted string. See EMR Auto Scaling documentation."
  type        = string
  default     = null
}

variable "configurations_json" {
  description = "A JSON string for supplying list of configurations specific to the EMR instance group. Note that this can only be changed when using EMR release 5.21 or later."
  type        = string
  default     = null
}

variable "ebs_config" {
  description = "One or more ebs_config blocks. Changing this forces a new resource to be created."
  type = list(object({
    iops                 = optional(number)
    size                 = optional(number)
    type                 = optional(string)
    volumes_per_instance = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.ebs_config : config.size == null || (config.size >= 1 && config.size <= 1024)
    ])
    error_message = "resource_aws_emr_instance_group, ebs_config.size must be between 1 and 1024 GiB when specified."
  }

  validation {
    condition = alltrue([
      for config in var.ebs_config : config.type == null || contains(["gp2", "io1", "standard"], config.type)
    ])
    error_message = "resource_aws_emr_instance_group, ebs_config.type must be one of: gp2, io1, standard."
  }

  validation {
    condition = alltrue([
      for config in var.ebs_config : config.iops == null || config.iops > 0
    ])
    error_message = "resource_aws_emr_instance_group, ebs_config.iops must be greater than 0 when specified."
  }

  validation {
    condition = alltrue([
      for config in var.ebs_config : config.volumes_per_instance == null || config.volumes_per_instance > 0
    ])
    error_message = "resource_aws_emr_instance_group, ebs_config.volumes_per_instance must be greater than 0 when specified."
  }
}