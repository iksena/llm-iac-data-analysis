variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "image_id" {
  description = "The EC2 image ID to launch"
  type        = string
}

variable "instance_type" {
  description = "The size of instance to launch"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type = list(object({
    device_name           = string
    snapshot_id           = optional(string)
    volume_type           = optional(string)
    volume_size           = optional(number)
    iops                  = optional(number)
    throughput            = optional(number)
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    no_device             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for device in var.ebs_block_device : contains(["standard", "gp2", "gp3", "st1", "sc1", "io1"], device.volume_type) if device.volume_type != null
    ])
    error_message = "resource_aws_launch_configuration, ebs_block_device.volume_type must be one of: standard, gp2, gp3, st1, sc1, io1."
  }

  validation {
    condition = alltrue([
      for device in var.ebs_block_device : device.iops != null if device.volume_type == "io1"
    ])
    error_message = "resource_aws_launch_configuration, ebs_block_device.iops must be set when volume_type is io1."
  }

  validation {
    condition = alltrue([
      for device in var.ebs_block_device : device.throughput != null if device.volume_type == "gp3"
    ])
    error_message = "resource_aws_launch_configuration, ebs_block_device.throughput can only be set for gp3 volume_type."
  }
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default"
  type        = bool
  default     = true
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type = list(object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  }))
  default = []
}

variable "iam_instance_profile" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = string
  default     = null
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = null
}

variable "metadata_options" {
  description = "The metadata options for the instance"
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
  })
  default = null

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.http_endpoint == null || contains(["enabled", "disabled"], var.metadata_options.http_endpoint)
    )
    error_message = "resource_aws_launch_configuration, metadata_options.http_endpoint must be either 'enabled' or 'disabled'."
  }

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.http_tokens == null || contains(["optional", "required"], var.metadata_options.http_tokens)
    )
    error_message = "resource_aws_launch_configuration, metadata_options.http_tokens must be either 'optional' or 'required'."
  }
}

variable "name" {
  description = "The name of the launch configuration. Conflicts with name_prefix"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "A list of associated security group IDS"
  type        = list(string)
  default     = null
}

variable "placement_tenancy" {
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'"
  type        = string
  default     = null

  validation {
    condition     = var.placement_tenancy == null || contains(["default", "dedicated"], var.placement_tenancy)
    error_message = "resource_aws_launch_configuration, placement_tenancy must be either 'default' or 'dedicated'."
  }
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type = object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
  })
  default = null

  validation {
    condition = var.root_block_device == null || (
      var.root_block_device.volume_type == null || contains(["standard", "gp2", "gp3", "st1", "sc1", "io1"], var.root_block_device.volume_type)
    )
    error_message = "resource_aws_launch_configuration, root_block_device.volume_type must be one of: standard, gp2, gp3, st1, sc1, io1."
  }

  validation {
    condition = var.root_block_device == null || (
      var.root_block_device.volume_type != "io1" || var.root_block_device.iops != null
    )
    error_message = "resource_aws_launch_configuration, root_block_device.iops must be set when volume_type is io1."
  }

  validation {
    condition = var.root_block_device == null || (
      var.root_block_device.volume_type == "gp3" || var.root_block_device.throughput == null
    )
    error_message = "resource_aws_launch_configuration, root_block_device.throughput can only be set for gp3 volume_type."
  }
}

variable "spot_price" {
  description = "The maximum price to use for reserving spot instances"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly"
  type        = string
  default     = null
}