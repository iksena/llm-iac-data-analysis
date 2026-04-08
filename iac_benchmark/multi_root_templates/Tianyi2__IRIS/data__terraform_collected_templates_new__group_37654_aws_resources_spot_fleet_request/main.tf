resource "aws_spot_fleet_request" "this" {
  region                              = var.region
  iam_fleet_role                      = var.iam_fleet_role
  context                             = var.context
  replace_unhealthy_instances         = var.replace_unhealthy_instances
  spot_price                          = var.spot_price
  wait_for_fulfillment                = var.wait_for_fulfillment
  target_capacity                     = var.target_capacity
  target_capacity_unit_type           = var.target_capacity_unit_type
  allocation_strategy                 = var.allocation_strategy
  instance_pools_to_use_count         = var.instance_pools_to_use_count
  excess_capacity_termination_policy  = var.excess_capacity_termination_policy
  terminate_instances_with_expiration = var.terminate_instances_with_expiration
  terminate_instances_on_delete       = var.terminate_instances_on_delete
  instance_interruption_behaviour     = var.instance_interruption_behaviour
  fleet_type                          = var.fleet_type
  valid_until                         = var.valid_until
  valid_from                          = var.valid_from
  load_balancers                      = var.load_balancers
  target_group_arns                   = var.target_group_arns
  on_demand_allocation_strategy       = var.on_demand_allocation_strategy
  on_demand_max_total_price           = var.on_demand_max_total_price
  on_demand_target_capacity           = var.on_demand_target_capacity
  tags                                = var.tags

  dynamic "launch_specification" {
    for_each = var.launch_specification
    content {
      ami               = launch_specification.value.ami
      availability_zone = launch_specification.value.availability_zone
      dynamic "ebs_block_device" {
        for_each = launch_specification.value.ebs_block_device != null ? launch_specification.value.ebs_block_device : []
        content {
          delete_on_termination = ebs_block_device.value.delete_on_termination
          device_name           = ebs_block_device.value.device_name
          encrypted             = ebs_block_device.value.encrypted
          iops                  = ebs_block_device.value.iops
          kms_key_id            = ebs_block_device.value.kms_key_id
          snapshot_id           = ebs_block_device.value.snapshot_id
          throughput            = ebs_block_device.value.throughput
          volume_size           = ebs_block_device.value.volume_size
          volume_type           = ebs_block_device.value.volume_type
        }
      }
      ebs_optimized = launch_specification.value.ebs_optimized
      dynamic "ephemeral_block_device" {
        for_each = launch_specification.value.ephemeral_block_device != null ? launch_specification.value.ephemeral_block_device : []
        content {
          device_name  = ephemeral_block_device.value.device_name
          virtual_name = ephemeral_block_device.value.virtual_name
        }
      }
      iam_instance_profile     = launch_specification.value.iam_instance_profile
      iam_instance_profile_arn = launch_specification.value.iam_instance_profile_arn
      instance_type            = launch_specification.value.instance_type
      key_name                 = launch_specification.value.key_name
      monitoring               = launch_specification.value.monitoring
      placement_group          = launch_specification.value.placement_group
      placement_tenancy        = launch_specification.value.placement_tenancy
      dynamic "root_block_device" {
        for_each = launch_specification.value.root_block_device != null ? [launch_specification.value.root_block_device] : []
        content {
          delete_on_termination = root_block_device.value.delete_on_termination
          encrypted             = root_block_device.value.encrypted
          iops                  = root_block_device.value.iops
          kms_key_id            = root_block_device.value.kms_key_id
          throughput            = root_block_device.value.throughput
          volume_size           = root_block_device.value.volume_size
          volume_type           = root_block_device.value.volume_type
        }
      }
      spot_price             = launch_specification.value.spot_price
      subnet_id              = launch_specification.value.subnet_id
      tags                   = launch_specification.value.tags
      user_data              = launch_specification.value.user_data
      vpc_security_group_ids = launch_specification.value.vpc_security_group_ids
      weighted_capacity      = launch_specification.value.weighted_capacity
    }
  }

  dynamic "launch_template_config" {
    for_each = var.launch_template_config
    content {
      dynamic "launch_template_specification" {
        for_each = [launch_template_config.value.launch_template_specification]
        content {
          id      = launch_template_specification.value.id
          name    = launch_template_specification.value.name
          version = launch_template_specification.value.version
        }
      }

      dynamic "overrides" {
        for_each = launch_template_config.value.overrides
        content {
          availability_zone = overrides.value.availability_zone
          instance_type     = overrides.value.instance_type
          priority          = overrides.value.priority
          spot_price        = overrides.value.spot_price
          subnet_id         = overrides.value.subnet_id
          weighted_capacity = overrides.value.weighted_capacity

          dynamic "instance_requirements" {
            for_each = overrides.value.instance_requirements != null ? [overrides.value.instance_requirements] : []
            content {
              dynamic "accelerator_count" {
                for_each = instance_requirements.value.accelerator_count != null ? [instance_requirements.value.accelerator_count] : []
                content {
                  min = accelerator_count.value.min
                  max = accelerator_count.value.max
                }
              }
              accelerator_manufacturers = instance_requirements.value.accelerator_manufacturers
              accelerator_names         = instance_requirements.value.accelerator_names
              dynamic "accelerator_total_memory_mib" {
                for_each = instance_requirements.value.accelerator_total_memory_mib != null ? [instance_requirements.value.accelerator_total_memory_mib] : []
                content {
                  min = accelerator_total_memory_mib.value.min
                  max = accelerator_total_memory_mib.value.max
                }
              }
              accelerator_types      = instance_requirements.value.accelerator_types
              allowed_instance_types = instance_requirements.value.allowed_instance_types
              bare_metal             = instance_requirements.value.bare_metal
              dynamic "baseline_ebs_bandwidth_mbps" {
                for_each = instance_requirements.value.baseline_ebs_bandwidth_mbps != null ? [instance_requirements.value.baseline_ebs_bandwidth_mbps] : []
                content {
                  min = baseline_ebs_bandwidth_mbps.value.min
                  max = baseline_ebs_bandwidth_mbps.value.max
                }
              }
              burstable_performance   = instance_requirements.value.burstable_performance
              cpu_manufacturers       = instance_requirements.value.cpu_manufacturers
              excluded_instance_types = instance_requirements.value.excluded_instance_types
              instance_generations    = instance_requirements.value.instance_generations
              local_storage           = instance_requirements.value.local_storage
              local_storage_types     = instance_requirements.value.local_storage_types
              dynamic "memory_gib_per_vcpu" {
                for_each = instance_requirements.value.memory_gib_per_vcpu != null ? [instance_requirements.value.memory_gib_per_vcpu] : []
                content {
                  min = memory_gib_per_vcpu.value.min
                  max = memory_gib_per_vcpu.value.max
                }
              }
              dynamic "memory_mib" {
                for_each = instance_requirements.value.memory_mib != null ? [instance_requirements.value.memory_mib] : []
                content {
                  min = memory_mib.value.min
                  max = memory_mib.value.max
                }
              }
              dynamic "network_bandwidth_gbps" {
                for_each = instance_requirements.value.network_bandwidth_gbps != null ? [instance_requirements.value.network_bandwidth_gbps] : []
                content {
                  min = network_bandwidth_gbps.value.min
                  max = network_bandwidth_gbps.value.max
                }
              }
              dynamic "network_interface_count" {
                for_each = instance_requirements.value.network_interface_count != null ? [instance_requirements.value.network_interface_count] : []
                content {
                  min = network_interface_count.value.min
                  max = network_interface_count.value.max
                }
              }
              on_demand_max_price_percentage_over_lowest_price = instance_requirements.value.on_demand_max_price_percentage_over_lowest_price
              require_hibernate_support                        = instance_requirements.value.require_hibernate_support
              spot_max_price_percentage_over_lowest_price      = instance_requirements.value.spot_max_price_percentage_over_lowest_price
              dynamic "total_local_storage_gb" {
                for_each = instance_requirements.value.total_local_storage_gb != null ? [instance_requirements.value.total_local_storage_gb] : []
                content {
                  min = total_local_storage_gb.value.min
                  max = total_local_storage_gb.value.max
                }
              }
              dynamic "vcpu_count" {
                for_each = instance_requirements.value.vcpu_count != null ? [instance_requirements.value.vcpu_count] : []
                content {
                  min = vcpu_count.value.min
                  max = vcpu_count.value.max
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "spot_maintenance_strategies" {
    for_each = var.spot_maintenance_strategies != null ? [var.spot_maintenance_strategies] : []
    content {
      dynamic "capacity_rebalance" {
        for_each = spot_maintenance_strategies.value.capacity_rebalance != null ? [spot_maintenance_strategies.value.capacity_rebalance] : []
        content {
          replacement_strategy = capacity_rebalance.value.replacement_strategy
        }
      }
    }
  }

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}