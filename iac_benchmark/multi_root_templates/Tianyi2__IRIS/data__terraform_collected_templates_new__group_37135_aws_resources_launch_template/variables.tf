variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "block_device_mappings" {
  type = list(object({
    device_name = string
    ebs = optional(object({
      delete_on_termination      = optional(bool)
      encrypted                  = optional(bool)
      iops                       = optional(number)
      kms_key_id                 = optional(string)
      snapshot_id                = optional(string)
      throughput                 = optional(number)
      volume_initialization_rate = optional(number)
      volume_size                = optional(number)
      volume_type                = optional(string)
    }))
    no_device    = optional(string)
    virtual_name = optional(string)
  }))
  default     = []
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI."

  validation {
    condition     = alltrue([for bdm in var.block_device_mappings : bdm.ebs == null || bdm.ebs.volume_type == null || contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], bdm.ebs.volume_type)])
    error_message = "resource_aws_launch_template, block_device_mappings volume_type must be one of: standard, gp2, gp3, io1, io2, sc1, st1."
  }

  validation {
    condition     = alltrue([for bdm in var.block_device_mappings : bdm.ebs == null || bdm.ebs.volume_initialization_rate == null || (bdm.ebs.volume_initialization_rate >= 100 && bdm.ebs.volume_initialization_rate <= 300)])
    error_message = "resource_aws_launch_template, block_device_mappings volume_initialization_rate must be between 100 and 300 MiB/s."
  }

  validation {
    condition     = alltrue([for bdm in var.block_device_mappings : bdm.ebs == null || bdm.ebs.throughput == null || bdm.ebs.throughput <= 1000])
    error_message = "resource_aws_launch_template, block_device_mappings throughput must be maximum 1000 MiB/s."
  }
}

variable "capacity_reservation_specification" {
  type = object({
    capacity_reservation_preference = optional(string)
    capacity_reservation_target = optional(object({
      capacity_reservation_id                 = optional(string)
      capacity_reservation_resource_group_arn = optional(string)
    }))
  })
  default     = null
  description = "Targeting for EC2 capacity reservations."

  validation {
    condition     = var.capacity_reservation_specification == null || var.capacity_reservation_specification.capacity_reservation_preference == null || contains(["capacity-reservations-only", "open", "none"], var.capacity_reservation_specification.capacity_reservation_preference)
    error_message = "resource_aws_launch_template, capacity_reservation_specification capacity_reservation_preference must be one of: capacity-reservations-only, open, none."
  }
}

variable "cpu_options" {
  type = object({
    amd_sev_snp      = optional(string)
    core_count       = optional(number)
    threads_per_core = optional(number)
  })
  default     = null
  description = "The CPU options for the instance."

  validation {
    condition     = var.cpu_options == null || var.cpu_options.amd_sev_snp == null || contains(["enabled", "disabled"], var.cpu_options.amd_sev_snp)
    error_message = "resource_aws_launch_template, cpu_options amd_sev_snp must be either enabled or disabled."
  }

  validation {
    condition     = var.cpu_options == null || (var.cpu_options.core_count == null || var.cpu_options.threads_per_core == null) || (var.cpu_options.core_count != null && var.cpu_options.threads_per_core != null)
    error_message = "resource_aws_launch_template, cpu_options both core_count and threads_per_core must be specified together."
  }
}

variable "credit_specification" {
  type = object({
    cpu_credits = optional(string)
  })
  default     = null
  description = "Customize the credit specification of the instance."

  validation {
    condition     = var.credit_specification == null || var.credit_specification.cpu_credits == null || contains(["standard", "unlimited"], var.credit_specification.cpu_credits)
    error_message = "resource_aws_launch_template, credit_specification cpu_credits must be either standard or unlimited."
  }
}

variable "default_version" {
  type        = string
  default     = null
  description = "Default Version of the launch template."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the launch template."
}

variable "disable_api_stop" {
  type        = bool
  default     = null
  description = "If true, enables EC2 Instance Stop Protection."
}

variable "disable_api_termination" {
  type        = bool
  default     = null
  description = "If true, enables EC2 Instance Termination Protection."
}

variable "ebs_optimized" {
  type        = bool
  default     = null
  description = "If true, the launched EC2 instance will be EBS-optimized."
}

variable "enclave_options" {
  type = object({
    enabled = optional(bool)
  })
  default     = null
  description = "Enable Nitro Enclaves on launched instances."
}

variable "hibernation_options" {
  type = object({
    configured = optional(bool)
  })
  default     = null
  description = "The hibernation options for the instance."
}

variable "iam_instance_profile" {
  type = object({
    arn  = optional(string)
    name = optional(string)
  })
  default     = null
  description = "The IAM Instance Profile to launch the instance with."

  validation {
    condition     = var.iam_instance_profile == null || (var.iam_instance_profile.arn == null || var.iam_instance_profile.name == null)
    error_message = "resource_aws_launch_template, iam_instance_profile arn and name are mutually exclusive."
  }
}

variable "image_id" {
  type        = string
  default     = null
  description = "The AMI from which to launch the instance or use a Systems Manager parameter convention."
}

variable "instance_initiated_shutdown_behavior" {
  type        = string
  default     = null
  description = "Shutdown behavior for the instance. Can be stop or terminate."

  validation {
    condition     = var.instance_initiated_shutdown_behavior == null || contains(["stop", "terminate"], var.instance_initiated_shutdown_behavior)
    error_message = "resource_aws_launch_template, instance_initiated_shutdown_behavior must be either stop or terminate."
  }
}

variable "instance_market_options" {
  type = object({
    market_type = optional(string)
    spot_options = optional(object({
      block_duration_minutes         = optional(number)
      instance_interruption_behavior = optional(string)
      max_price                      = optional(string)
      spot_instance_type             = optional(string)
      valid_until                    = optional(string)
    }))
  })
  default     = null
  description = "The market (purchasing) option for the instance."

  validation {
    condition     = var.instance_market_options == null || var.instance_market_options.market_type == null || var.instance_market_options.market_type == "spot"
    error_message = "resource_aws_launch_template, instance_market_options market_type must be spot."
  }

  validation {
    condition     = var.instance_market_options == null || var.instance_market_options.spot_options == null || var.instance_market_options.spot_options.instance_interruption_behavior == null || contains(["hibernate", "stop", "terminate"], var.instance_market_options.spot_options.instance_interruption_behavior)
    error_message = "resource_aws_launch_template, instance_market_options spot_options instance_interruption_behavior must be one of: hibernate, stop, terminate."
  }

  validation {
    condition     = var.instance_market_options == null || var.instance_market_options.spot_options == null || var.instance_market_options.spot_options.spot_instance_type == null || contains(["one-time", "persistent"], var.instance_market_options.spot_options.spot_instance_type)
    error_message = "resource_aws_launch_template, instance_market_options spot_options spot_instance_type must be one of: one-time, persistent."
  }

  validation {
    condition     = var.instance_market_options == null || var.instance_market_options.spot_options == null || var.instance_market_options.spot_options.block_duration_minutes == null || var.instance_market_options.spot_options.block_duration_minutes % 60 == 0
    error_message = "resource_aws_launch_template, instance_market_options spot_options block_duration_minutes must be a multiple of 60."
  }
}

variable "instance_requirements" {
  type = object({
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
    memory_mib = object({
      min = number
      max = optional(number)
    })
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
    vcpu_count = object({
      min = number
      max = optional(number)
    })
  })
  default     = null
  description = "The attribute requirements for the type of instance. If present then instance_type cannot be present."

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.accelerator_manufacturers == null || alltrue([for am in var.instance_requirements.accelerator_manufacturers : contains(["amazon-web-services", "amd", "nvidia", "xilinx"], am)])
    error_message = "resource_aws_launch_template, instance_requirements accelerator_manufacturers must be one of: amazon-web-services, amd, nvidia, xilinx."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.accelerator_names == null || alltrue([for an in var.instance_requirements.accelerator_names : contains(["a100", "v100", "k80", "t4", "m60", "radeon-pro-v520", "vu9p"], an)])
    error_message = "resource_aws_launch_template, instance_requirements accelerator_names must be one of: a100, v100, k80, t4, m60, radeon-pro-v520, vu9p."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.accelerator_types == null || alltrue([for at in var.instance_requirements.accelerator_types : contains(["fpga", "gpu", "inference"], at)])
    error_message = "resource_aws_launch_template, instance_requirements accelerator_types must be one of: fpga, gpu, inference."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.bare_metal == null || contains(["included", "excluded", "required"], var.instance_requirements.bare_metal)
    error_message = "resource_aws_launch_template, instance_requirements bare_metal must be one of: included, excluded, required."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.burstable_performance == null || contains(["included", "excluded", "required"], var.instance_requirements.burstable_performance)
    error_message = "resource_aws_launch_template, instance_requirements burstable_performance must be one of: included, excluded, required."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.cpu_manufacturers == null || alltrue([for cm in var.instance_requirements.cpu_manufacturers : contains(["amazon-web-services", "amd", "intel"], cm)])
    error_message = "resource_aws_launch_template, instance_requirements cpu_manufacturers must be one of: amazon-web-services, amd, intel."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.instance_generations == null || alltrue([for ig in var.instance_requirements.instance_generations : contains(["current", "previous"], ig)])
    error_message = "resource_aws_launch_template, instance_requirements instance_generations must be one of: current, previous."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.local_storage == null || contains(["included", "excluded", "required"], var.instance_requirements.local_storage)
    error_message = "resource_aws_launch_template, instance_requirements local_storage must be one of: included, excluded, required."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.local_storage_types == null || alltrue([for lst in var.instance_requirements.local_storage_types : contains(["hdd", "ssd"], lst)])
    error_message = "resource_aws_launch_template, instance_requirements local_storage_types must be one of: hdd, ssd."
  }

  validation {
    condition     = var.instance_requirements == null || (var.instance_requirements.allowed_instance_types == null || var.instance_requirements.excluded_instance_types == null)
    error_message = "resource_aws_launch_template, instance_requirements allowed_instance_types and excluded_instance_types are mutually exclusive."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.allowed_instance_types == null || length(var.instance_requirements.allowed_instance_types) <= 400
    error_message = "resource_aws_launch_template, instance_requirements allowed_instance_types maximum of 400 entries allowed."
  }

  validation {
    condition     = var.instance_requirements == null || var.instance_requirements.excluded_instance_types == null || length(var.instance_requirements.excluded_instance_types) <= 400
    error_message = "resource_aws_launch_template, instance_requirements excluded_instance_types maximum of 400 entries allowed."
  }

  validation {
    condition     = var.instance_requirements == null || (var.instance_requirements.max_spot_price_as_percentage_of_optimal_on_demand_price == null || var.instance_requirements.spot_max_price_percentage_over_lowest_price == null)
    error_message = "resource_aws_launch_template, instance_requirements max_spot_price_as_percentage_of_optimal_on_demand_price and spot_max_price_percentage_over_lowest_price are mutually exclusive."
  }
}

variable "instance_type" {
  type        = string
  default     = null
  description = "The type of the instance. If present then instance_requirements cannot be present."
}

variable "kernel_id" {
  type        = string
  default     = null
  description = "The kernel ID."
}

variable "key_name" {
  type        = string
  default     = null
  description = "The key name to use for the instance."
}

variable "license_specification" {
  type = list(object({
    license_configuration_arn = string
  }))
  default     = []
  description = "A list of license specifications to associate with."
}

variable "maintenance_options" {
  type = object({
    auto_recovery = optional(string)
  })
  default     = null
  description = "The maintenance options for the instance."

  validation {
    condition     = var.maintenance_options == null || var.maintenance_options.auto_recovery == null || contains(["default", "disabled"], var.maintenance_options.auto_recovery)
    error_message = "resource_aws_launch_template, maintenance_options auto_recovery must be either default or disabled."
  }
}

variable "metadata_options" {
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    http_protocol_ipv6          = optional(string)
    instance_metadata_tags      = optional(string)
  })
  default     = null
  description = "Customize the metadata options for the instance."

  validation {
    condition     = var.metadata_options == null || var.metadata_options.http_endpoint == null || contains(["enabled", "disabled"], var.metadata_options.http_endpoint)
    error_message = "resource_aws_launch_template, metadata_options http_endpoint must be either enabled or disabled."
  }

  validation {
    condition     = var.metadata_options == null || var.metadata_options.http_tokens == null || contains(["optional", "required"], var.metadata_options.http_tokens)
    error_message = "resource_aws_launch_template, metadata_options http_tokens must be either optional or required."
  }

  validation {
    condition     = var.metadata_options == null || var.metadata_options.http_put_response_hop_limit == null || (var.metadata_options.http_put_response_hop_limit >= 1 && var.metadata_options.http_put_response_hop_limit <= 64)
    error_message = "resource_aws_launch_template, metadata_options http_put_response_hop_limit must be between 1 and 64."
  }

  validation {
    condition     = var.metadata_options == null || var.metadata_options.http_protocol_ipv6 == null || contains(["enabled", "disabled"], var.metadata_options.http_protocol_ipv6)
    error_message = "resource_aws_launch_template, metadata_options http_protocol_ipv6 must be either enabled or disabled."
  }

  validation {
    condition     = var.metadata_options == null || var.metadata_options.instance_metadata_tags == null || contains(["enabled", "disabled"], var.metadata_options.instance_metadata_tags)
    error_message = "resource_aws_launch_template, metadata_options instance_metadata_tags must be either enabled or disabled."
  }
}

variable "monitoring" {
  type = object({
    enabled = optional(bool)
  })
  default     = null
  description = "The monitoring option for the instance."
}

variable "name" {
  type        = string
  default     = null
  description = "The name of the launch template. If you leave this blank, Terraform will auto-generate a unique name."
}

variable "name_prefix" {
  type        = string
  default     = null
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
}

variable "network_interfaces" {
  type = list(object({
    associate_carrier_ip_address = optional(bool)
    associate_public_ip_address  = optional(bool)
    delete_on_termination        = optional(bool)
    description                  = optional(string)
    device_index                 = optional(number)
    interface_type               = optional(string)
    ipv4_prefix_count            = optional(number)
    ipv4_prefixes                = optional(list(string))
    ipv6_addresses               = optional(list(string))
    ipv6_address_count           = optional(number)
    ipv6_prefix_count            = optional(number)
    ipv6_prefixes                = optional(list(string))
    network_interface_id         = optional(string)
    network_card_index           = optional(number)
    primary_ipv6                 = optional(bool)
    private_ip_address           = optional(string)
    ipv4_address_count           = optional(number)
    ipv4_addresses               = optional(list(string))
    security_groups              = optional(list(string))
    subnet_id                    = optional(string)
    ena_srd_specification = optional(object({
      ena_srd_enabled = optional(bool)
      ena_srd_udp_specification = optional(object({
        ena_srd_udp_enabled = optional(bool)
      }))
    }))
    connection_tracking_specification = optional(object({
      tcp_established_timeout = optional(number)
      udp_stream_timeout      = optional(number)
      udp_timeout             = optional(number)
    }))
  }))
  default     = []
  description = "Customize network interfaces to be attached at instance boot time."

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.interface_type == null || ni.interface_type == "efa"])
    error_message = "resource_aws_launch_template, network_interfaces interface_type must be efa when specified."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.ipv4_prefix_count == null || ni.ipv4_prefixes == null])
    error_message = "resource_aws_launch_template, network_interfaces ipv4_prefix_count and ipv4_prefixes are mutually exclusive."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.ipv6_addresses == null || ni.ipv6_address_count == null])
    error_message = "resource_aws_launch_template, network_interfaces ipv6_addresses and ipv6_address_count are mutually exclusive."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.ipv6_prefix_count == null || ni.ipv6_prefixes == null])
    error_message = "resource_aws_launch_template, network_interfaces ipv6_prefix_count and ipv6_prefixes are mutually exclusive."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.ipv4_address_count == null || ni.ipv4_addresses == null])
    error_message = "resource_aws_launch_template, network_interfaces ipv4_address_count and ipv4_addresses are mutually exclusive."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.connection_tracking_specification == null || ni.connection_tracking_specification.tcp_established_timeout == null || (ni.connection_tracking_specification.tcp_established_timeout >= 60 && ni.connection_tracking_specification.tcp_established_timeout <= 432000)])
    error_message = "resource_aws_launch_template, network_interfaces connection_tracking_specification tcp_established_timeout must be between 60 and 432000 seconds."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.connection_tracking_specification == null || ni.connection_tracking_specification.udp_stream_timeout == null || (ni.connection_tracking_specification.udp_stream_timeout >= 30 && ni.connection_tracking_specification.udp_stream_timeout <= 60)])
    error_message = "resource_aws_launch_template, network_interfaces connection_tracking_specification udp_stream_timeout must be between 30 and 60 seconds."
  }

  validation {
    condition     = alltrue([for ni in var.network_interfaces : ni.connection_tracking_specification == null || ni.connection_tracking_specification.udp_timeout == null || (ni.connection_tracking_specification.udp_timeout >= 60 && ni.connection_tracking_specification.udp_timeout <= 180)])
    error_message = "resource_aws_launch_template, network_interfaces connection_tracking_specification udp_timeout must be between 60 and 180 seconds."
  }
}

variable "placement" {
  type = object({
    affinity                = optional(string)
    availability_zone       = optional(string)
    group_id                = optional(string)
    group_name              = optional(string)
    host_id                 = optional(string)
    host_resource_group_arn = optional(string)
    spread_domain           = optional(string)
    tenancy                 = optional(string)
    partition_number        = optional(number)
  })
  default     = null
  description = "The placement of the instance."

  validation {
    condition     = var.placement == null || var.placement.tenancy == null || contains(["default", "dedicated", "host"], var.placement.tenancy)
    error_message = "resource_aws_launch_template, placement tenancy must be one of: default, dedicated, host."
  }

  validation {
    condition     = var.placement == null || (var.placement.group_id == null || var.placement.group_name == null)
    error_message = "resource_aws_launch_template, placement group_id and group_name are mutually exclusive."
  }
}

variable "private_dns_name_options" {
  type = object({
    enable_resource_name_dns_aaaa_record = optional(bool)
    enable_resource_name_dns_a_record    = optional(bool)
    hostname_type                        = optional(string)
  })
  default     = null
  description = "The options for the instance hostname. The default values are inherited from the subnet."

  validation {
    condition     = var.private_dns_name_options == null || var.private_dns_name_options.hostname_type == null || contains(["ip-name", "resource-name"], var.private_dns_name_options.hostname_type)
    error_message = "resource_aws_launch_template, private_dns_name_options hostname_type must be either ip-name or resource-name."
  }
}

variable "ram_disk_id" {
  type        = string
  default     = null
  description = "The ID of the RAM disk."
}

variable "security_group_names" {
  type        = list(string)
  default     = []
  description = "A list of security group names to associate with. If you are creating Instances in a VPC, use vpc_security_group_ids instead."
}

variable "tag_specifications" {
  type = list(object({
    resource_type = optional(string)
    tags          = optional(map(string))
  }))
  default     = []
  description = "The tags to apply to the resources during launch."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the launch template."
}

variable "update_default_version" {
  type        = bool
  default     = null
  description = "Whether to update Default Version each update. Conflicts with default_version."
}

variable "user_data" {
  type        = string
  default     = null
  description = "The base64-encoded user data to provide when launching the instance."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = []
  description = "A list of security group IDs to associate with. Conflicts with network_interfaces.security_groups."
}