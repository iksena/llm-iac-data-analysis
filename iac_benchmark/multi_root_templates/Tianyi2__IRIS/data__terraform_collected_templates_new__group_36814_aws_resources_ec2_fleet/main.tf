resource "aws_ec2_fleet" "this" {
  region                              = var.region
  context                             = var.context
  excess_capacity_termination_policy  = var.excess_capacity_termination_policy
  replace_unhealthy_instances         = var.replace_unhealthy_instances
  tags                                = var.tags
  terminate_instances                 = var.terminate_instances
  terminate_instances_with_expiration = var.terminate_instances_with_expiration
  type                                = var.type
  valid_from                          = var.valid_from
  valid_until                         = var.valid_until

  dynamic "launch_template_config" {
    for_each = var.launch_template_config
    content {
      dynamic "launch_template_specification" {
        for_each = launch_template_config.value.launch_template_specification != null ? [launch_template_config.value.launch_template_specification] : []
        content {
          launch_template_id   = launch_template_specification.value.launch_template_id
          launch_template_name = launch_template_specification.value.launch_template_name
          version              = launch_template_specification.value.version
        }
      }

      dynamic "override" {
        for_each = launch_template_config.value.override != null ? launch_template_config.value.override : []
        content {
          availability_zone = override.value.availability_zone
          instance_type     = override.value.instance_type
          max_price         = override.value.max_price
          priority          = override.value.priority
          subnet_id         = override.value.subnet_id
          weighted_capacity = override.value.weighted_capacity

          dynamic "instance_requirements" {
            for_each = override.value.instance_requirements != null ? [override.value.instance_requirements] : []
            content {
              accelerator_manufacturers                               = instance_requirements.value.accelerator_manufacturers
              accelerator_names                                       = instance_requirements.value.accelerator_names
              accelerator_types                                       = instance_requirements.value.accelerator_types
              allowed_instance_types                                  = instance_requirements.value.allowed_instance_types
              bare_metal                                              = instance_requirements.value.bare_metal
              burstable_performance                                   = instance_requirements.value.burstable_performance
              cpu_manufacturers                                       = instance_requirements.value.cpu_manufacturers
              excluded_instance_types                                 = instance_requirements.value.excluded_instance_types
              instance_generations                                    = instance_requirements.value.instance_generations
              local_storage                                           = instance_requirements.value.local_storage
              local_storage_types                                     = instance_requirements.value.local_storage_types
              max_spot_price_as_percentage_of_optimal_on_demand_price = instance_requirements.value.max_spot_price_as_percentage_of_optimal_on_demand_price
              on_demand_max_price_percentage_over_lowest_price        = instance_requirements.value.on_demand_max_price_percentage_over_lowest_price
              require_hibernate_support                               = instance_requirements.value.require_hibernate_support
              spot_max_price_percentage_over_lowest_price             = instance_requirements.value.spot_max_price_percentage_over_lowest_price

              dynamic "accelerator_count" {
                for_each = instance_requirements.value.accelerator_count != null ? [instance_requirements.value.accelerator_count] : []
                content {
                  min = accelerator_count.value.min
                  max = accelerator_count.value.max
                }
              }

              dynamic "accelerator_total_memory_mib" {
                for_each = instance_requirements.value.accelerator_total_memory_mib != null ? [instance_requirements.value.accelerator_total_memory_mib] : []
                content {
                  min = accelerator_total_memory_mib.value.min
                  max = accelerator_total_memory_mib.value.max
                }
              }

              dynamic "baseline_ebs_bandwidth_mbps" {
                for_each = instance_requirements.value.baseline_ebs_bandwidth_mbps != null ? [instance_requirements.value.baseline_ebs_bandwidth_mbps] : []
                content {
                  min = baseline_ebs_bandwidth_mbps.value.min
                  max = baseline_ebs_bandwidth_mbps.value.max
                }
              }

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

  dynamic "on_demand_options" {
    for_each = var.on_demand_options != null ? [var.on_demand_options] : []
    content {
      allocation_strategy      = on_demand_options.value.allocation_strategy
      max_total_price          = on_demand_options.value.max_total_price
      min_target_capacity      = on_demand_options.value.min_target_capacity
      single_availability_zone = on_demand_options.value.single_availability_zone
      single_instance_type     = on_demand_options.value.single_instance_type

      dynamic "capacity_reservation_options" {
        for_each = on_demand_options.value.capacity_reservation_options != null ? [on_demand_options.value.capacity_reservation_options] : []
        content {
          usage_strategy = capacity_reservation_options.value.usage_strategy
        }
      }
    }
  }

  dynamic "spot_options" {
    for_each = var.spot_options != null ? [var.spot_options] : []
    content {
      allocation_strategy            = spot_options.value.allocation_strategy
      instance_interruption_behavior = spot_options.value.instance_interruption_behavior
      instance_pools_to_use_count    = spot_options.value.instance_pools_to_use_count
      max_total_price                = spot_options.value.max_total_price
      min_target_capacity            = spot_options.value.min_target_capacity
      single_availability_zone       = spot_options.value.single_availability_zone
      single_instance_type           = spot_options.value.single_instance_type

      dynamic "maintenance_strategies" {
        for_each = spot_options.value.maintenance_strategies != null ? [spot_options.value.maintenance_strategies] : []
        content {
          dynamic "capacity_rebalance" {
            for_each = maintenance_strategies.value.capacity_rebalance != null ? [maintenance_strategies.value.capacity_rebalance] : []
            content {
              replacement_strategy = capacity_rebalance.value.replacement_strategy
            }
          }
        }
      }
    }
  }

  target_capacity_specification {
    default_target_capacity_type = var.target_capacity_specification.default_target_capacity_type
    on_demand_target_capacity    = var.target_capacity_specification.on_demand_target_capacity
    spot_target_capacity         = var.target_capacity_specification.spot_target_capacity
    target_capacity_unit_type    = var.target_capacity_specification.target_capacity_unit_type
    total_target_capacity        = var.target_capacity_specification.total_target_capacity
  }
}