variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "ami" {
  description = "AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC."
  type        = bool
  default     = null
}

variable "availability_zone" {
  description = "AZ to start the instance in."
  type        = string
  default     = null
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option."
  type = object({
    capacity_reservation_preference = optional(string)
    capacity_reservation_target = optional(object({
      capacity_reservation_id                 = optional(string)
      capacity_reservation_resource_group_arn = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.capacity_reservation_specification == null || (
      var.capacity_reservation_specification.capacity_reservation_preference == null ||
      contains(["open", "none"], var.capacity_reservation_specification.capacity_reservation_preference)
    )
    error_message = "resource_aws_instance, capacity_reservation_specification.capacity_reservation_preference must be one of: 'open', 'none'."
  }
}

variable "cpu_options" {
  description = "The CPU options for the instance."
  type = object({
    amd_sev_snp      = optional(string)
    core_count       = optional(number)
    threads_per_core = optional(number)
  })
  default = null

  validation {
    condition = var.cpu_options == null || (
      var.cpu_options.amd_sev_snp == null ||
      contains(["enabled", "disabled"], var.cpu_options.amd_sev_snp)
    )
    error_message = "resource_aws_instance, cpu_options.amd_sev_snp must be one of: 'enabled', 'disabled'."
  }
}

variable "credit_specification" {
  description = "Configuration block for customizing the credit specification of the instance."
  type = object({
    cpu_credits = optional(string)
  })
  default = null

  validation {
    condition = var.credit_specification == null || (
      var.credit_specification.cpu_credits == null ||
      contains(["standard", "unlimited"], var.credit_specification.cpu_credits)
    )
    error_message = "resource_aws_instance, credit_specification.cpu_credits must be one of: 'standard', 'unlimited'."
  }
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection."
  type        = bool
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection."
  type        = bool
  default     = null
}

variable "ebs_block_device" {
  description = "One or more configuration blocks with additional EBS block devices to attach to the instance."
  type = list(object({
    delete_on_termination = optional(bool)
    device_name           = string
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    snapshot_id           = optional(string)
    tags                  = optional(map(string))
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for device in var.ebs_block_device : (
        device.volume_type == null ||
        contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], device.volume_type)
      )
    ])
    error_message = "resource_aws_instance, ebs_block_device.volume_type must be one of: 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', 'st1'."
  }
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized."
  type        = bool
  default     = null
}

variable "enable_primary_ipv6" {
  description = "Whether to assign a primary IPv6 Global Unicast Address (GUA) to the instance when launched in a dual-stack or IPv6-only subnet."
  type        = bool
  default     = null
}

variable "enclave_options" {
  description = "Enable Nitro Enclaves on launched instances."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "ephemeral_block_device" {
  description = "One or more configuration blocks to customize Ephemeral (also known as Instance Store) volumes on the instance."
  type = list(object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  }))
  default = []
}

variable "force_destroy" {
  description = "Destroys instance even if disable_api_termination or disable_api_stop is set to true."
  type        = bool
  default     = false
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation."
  type        = bool
  default     = null
}

variable "host_id" {
  description = "ID of a dedicated host that the instance will be assigned to."
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "ARN of the host resource group in which to launch the instances."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with."
  type        = string
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance."
  type        = string
  default     = null

  validation {
    condition     = var.instance_initiated_shutdown_behavior == null || contains(["stop", "terminate"], var.instance_initiated_shutdown_behavior)
    error_message = "resource_aws_instance, instance_initiated_shutdown_behavior must be one of: 'stop', 'terminate'."
  }
}

variable "instance_market_options" {
  description = "Describes the market (purchasing) option for the instances."
  type = object({
    market_type = optional(string)
    spot_options = optional(object({
      instance_interruption_behavior = optional(string)
      max_price                      = optional(string)
      spot_instance_type             = optional(string)
      valid_until                    = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.instance_market_options == null || (
      var.instance_market_options.market_type == null ||
      contains(["spot", "capacity-block"], var.instance_market_options.market_type)
    )
    error_message = "resource_aws_instance, instance_market_options.market_type must be one of: 'spot', 'capacity-block'."
  }

  validation {
    condition = var.instance_market_options == null || var.instance_market_options.spot_options == null || (
      var.instance_market_options.spot_options.instance_interruption_behavior == null ||
      contains(["hibernate", "stop", "terminate"], var.instance_market_options.spot_options.instance_interruption_behavior)
    )
    error_message = "resource_aws_instance, instance_market_options.spot_options.instance_interruption_behavior must be one of: 'hibernate', 'stop', 'terminate'."
  }

  validation {
    condition = var.instance_market_options == null || var.instance_market_options.spot_options == null || (
      var.instance_market_options.spot_options.spot_instance_type == null ||
      contains(["one-time", "persistent"], var.instance_market_options.spot_options.spot_instance_type)
    )
    error_message = "resource_aws_instance, instance_market_options.spot_options.spot_instance_type must be one of: 'one-time', 'persistent'."
  }
}

variable "instance_type" {
  description = "Instance type to use for the instance."
  type        = string
  default     = null
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to associate with the primary network interface."
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface."
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance."
  type        = string
  default     = null
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance."
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = optional(string)
  })
  default = null

  validation {
    condition = var.launch_template == null || !(
      var.launch_template.id != null && var.launch_template.name != null
    )
    error_message = "resource_aws_instance, launch_template cannot specify both id and name."
  }
}

variable "maintenance_options" {
  description = "Maintenance and recovery options for the instance."
  type = object({
    auto_recovery = optional(string)
  })
  default = null

  validation {
    condition = var.maintenance_options == null || (
      var.maintenance_options.auto_recovery == null ||
      contains(["default", "disabled"], var.maintenance_options.auto_recovery)
    )
    error_message = "resource_aws_instance, maintenance_options.auto_recovery must be one of: 'default', 'disabled'."
  }
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance."
  type = object({
    http_endpoint               = optional(string)
    http_protocol_ipv6          = optional(string)
    http_put_response_hop_limit = optional(number)
    http_tokens                 = optional(string)
    instance_metadata_tags      = optional(string)
  })
  default = null

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.http_endpoint == null ||
      contains(["enabled", "disabled"], var.metadata_options.http_endpoint)
    )
    error_message = "resource_aws_instance, metadata_options.http_endpoint must be one of: 'enabled', 'disabled'."
  }

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.http_protocol_ipv6 == null ||
      contains(["enabled", "disabled"], var.metadata_options.http_protocol_ipv6)
    )
    error_message = "resource_aws_instance, metadata_options.http_protocol_ipv6 must be one of: 'enabled', 'disabled'."
  }

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.http_put_response_hop_limit == null ||
      (var.metadata_options.http_put_response_hop_limit >= 1 && var.metadata_options.http_put_response_hop_limit <= 64)
    )
    error_message = "resource_aws_instance, metadata_options.http_put_response_hop_limit must be between 1 and 64."
  }

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.http_tokens == null ||
      contains(["optional", "required"], var.metadata_options.http_tokens)
    )
    error_message = "resource_aws_instance, metadata_options.http_tokens must be one of: 'optional', 'required'."
  }

  validation {
    condition = var.metadata_options == null || (
      var.metadata_options.instance_metadata_tags == null ||
      contains(["enabled", "disabled"], var.metadata_options.instance_metadata_tags)
    )
    error_message = "resource_aws_instance, metadata_options.instance_metadata_tags must be one of: 'enabled', 'disabled'."
  }
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = null
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time. (Deprecated - use primary_network_interface for primary interface)"
  type = list(object({
    delete_on_termination = optional(bool)
    device_index          = number
    network_card_index    = optional(number)
    network_interface_id  = string
  }))
  default = []
}

variable "placement_group" {
  description = "Placement Group to start the instance in. Conflicts with placement_group_id."
  type        = string
  default     = null
}

variable "placement_group_id" {
  description = "Placement Group ID to start the instance in. Conflicts with placement_group."
  type        = string
  default     = null

  validation {
    condition     = !(var.placement_group != null && var.placement_group_id != null)
    error_message = "resource_aws_instance, placement_group_id conflicts with placement_group. Only one can be specified."
  }
}

variable "placement_partition_number" {
  description = "Number of the partition the instance is in."
  type        = number
  default     = null
}

variable "primary_network_interface" {
  description = "The primary network interface."
  type = object({
    network_interface_id = string
  })
  default = null
}

variable "private_dns_name_options" {
  description = "Options for the instance hostname."
  type = object({
    enable_resource_name_dns_aaaa_record = optional(bool)
    enable_resource_name_dns_a_record    = optional(bool)
    hostname_type                        = optional(string)
  })
  default = null

  validation {
    condition = var.private_dns_name_options == null || (
      var.private_dns_name_options.hostname_type == null ||
      contains(["ip-name", "resource-name"], var.private_dns_name_options.hostname_type)
    )
    error_message = "resource_aws_instance, private_dns_name_options.hostname_type must be one of: 'ip-name', 'resource-name'."
  }
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC."
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Configuration block to customize details about the root block device of the instance."
  type = object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    tags                  = optional(map(string))
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
  })
  default = null

  validation {
    condition = var.root_block_device == null || (
      var.root_block_device.volume_type == null ||
      contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], var.root_block_device.volume_type)
    )
    error_message = "resource_aws_instance, root_block_device.volume_type must be one of: 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', 'st1'."
  }
}

variable "secondary_private_ips" {
  description = "List of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC."
  type        = list(string)
  default     = null
}

variable "security_groups" {
  description = "List of security group names to associate with. (EC2-Classic and default VPC only)"
  type        = list(string)
  default     = null
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "Tenancy of the instance (if the instance is running in a VPC)."
  type        = string
  default     = null

  validation {
    condition     = var.tenancy == null || contains(["default", "dedicated", "host"], var.tenancy)
    error_message = "resource_aws_instance, tenancy must be one of: 'default', 'dedicated', 'host'."
  }
}

variable "user_data" {
  description = "User data to provide when launching the instance."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate of the EC2 instance when set to true."
  type        = bool
  default     = false
}

variable "volume_tags" {
  description = "Map of tags to assign, at instance-creation time, to root and EBS volumes."
  type        = map(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with. (VPC only)"
  type        = list(string)
  default     = null
}