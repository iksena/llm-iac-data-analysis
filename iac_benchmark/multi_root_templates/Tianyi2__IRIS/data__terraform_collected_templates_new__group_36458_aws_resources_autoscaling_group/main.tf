resource "aws_autoscaling_group" "this" {
  region                           = var.region
  name                             = var.name
  name_prefix                      = var.name_prefix
  max_size                         = var.max_size
  min_size                         = var.min_size
  availability_zones               = var.availability_zones
  capacity_rebalance               = var.capacity_rebalance
  context                          = var.context
  default_cooldown                 = var.default_cooldown
  default_instance_warmup          = var.default_instance_warmup
  launch_configuration             = var.launch_configuration
  ignore_failed_scaling_activities = var.ignore_failed_scaling_activities
  health_check_grace_period        = var.health_check_grace_period
  health_check_type                = var.health_check_type
  desired_capacity                 = var.desired_capacity
  desired_capacity_type            = var.desired_capacity_type
  force_delete                     = var.force_delete
  load_balancers                   = var.load_balancers
  vpc_zone_identifier              = var.vpc_zone_identifier
  target_group_arns                = var.target_group_arns
  termination_policies             = var.termination_policies
  suspended_processes              = var.suspended_processes
  placement_group                  = var.placement_group
  metrics_granularity              = var.metrics_granularity
  enabled_metrics                  = var.enabled_metrics
  wait_for_capacity_timeout        = var.wait_for_capacity_timeout
  min_elb_capacity                 = var.min_elb_capacity
  wait_for_elb_capacity            = var.wait_for_elb_capacity
  protect_from_scale_in            = var.protect_from_scale_in
  service_linked_role_arn          = var.service_linked_role_arn
  max_instance_lifetime            = var.max_instance_lifetime
  force_delete_warm_pool           = var.force_delete_warm_pool

  dynamic "availability_zone_distribution" {
    for_each = var.availability_zone_distribution != null ? [var.availability_zone_distribution] : []
    content {
      capacity_distribution_strategy = availability_zone_distribution.value.capacity_distribution_strategy
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = capacity_reservation_specification.value.capacity_reservation_preference

      dynamic "capacity_reservation_target" {
        for_each = capacity_reservation_specification.value.capacity_reservation_target != null ? [capacity_reservation_specification.value.capacity_reservation_target] : []
        content {
          capacity_reservation_ids                 = capacity_reservation_target.value.capacity_reservation_ids
          capacity_reservation_resource_group_arns = capacity_reservation_target.value.capacity_reservation_resource_group_arns
        }
      }
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = launch_template.value.id
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.mixed_instances_policy != null ? [var.mixed_instances_policy] : []
    content {
      dynamic "instances_distribution" {
        for_each = mixed_instances_policy.value.instances_distribution != null ? [mixed_instances_policy.value.instances_distribution] : []
        content {
          on_demand_allocation_strategy            = instances_distribution.value.on_demand_allocation_strategy
          on_demand_base_capacity                  = instances_distribution.value.on_demand_base_capacity
          on_demand_percentage_above_base_capacity = instances_distribution.value.on_demand_percentage_above_base_capacity
          spot_allocation_strategy                 = instances_distribution.value.spot_allocation_strategy
          spot_instance_pools                      = instances_distribution.value.spot_instance_pools
          spot_max_price                           = instances_distribution.value.spot_max_price
        }
      }

      launch_template {
        launch_template_specification {
          launch_template_id   = mixed_instances_policy.value.launch_template.launch_template_specification.launch_template_id
          launch_template_name = mixed_instances_policy.value.launch_template.launch_template_specification.launch_template_name
          version              = mixed_instances_policy.value.launch_template.launch_template_specification.version
        }

        dynamic "override" {
          for_each = mixed_instances_policy.value.launch_template.override != null ? mixed_instances_policy.value.launch_template.override : []
          content {
            instance_type     = override.value.instance_type
            weighted_capacity = override.value.weighted_capacity

            dynamic "instance_requirements" {
              for_each = override.value.instance_requirements != null ? [override.value.instance_requirements] : []
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

                burstable_performance                                   = instance_requirements.value.burstable_performance
                cpu_manufacturers                                       = instance_requirements.value.cpu_manufacturers
                excluded_instance_types                                 = instance_requirements.value.excluded_instance_types
                instance_generations                                    = instance_requirements.value.instance_generations
                local_storage                                           = instance_requirements.value.local_storage
                local_storage_types                                     = instance_requirements.value.local_storage_types
                max_spot_price_as_percentage_of_optimal_on_demand_price = instance_requirements.value.max_spot_price_as_percentage_of_optimal_on_demand_price

                dynamic "memory_gib_per_vcpu" {
                  for_each = instance_requirements.value.memory_gib_per_vcpu != null ? [instance_requirements.value.memory_gib_per_vcpu] : []
                  content {
                    min = memory_gib_per_vcpu.value.min
                    max = memory_gib_per_vcpu.value.max
                  }
                }

                memory_mib {
                  min = instance_requirements.value.memory_mib.min
                  max = instance_requirements.value.memory_mib.max
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

                vcpu_count {
                  min = instance_requirements.value.vcpu_count.min
                  max = instance_requirements.value.vcpu_count.max
                }
              }
            }

            dynamic "launch_template_specification" {
              for_each = override.value.launch_template_specification != null ? [override.value.launch_template_specification] : []
              content {
                launch_template_id   = launch_template_specification.value.launch_template_id
                launch_template_name = launch_template_specification.value.launch_template_name
                version              = launch_template_specification.value.version
              }
            }
          }
        }
      }
    }
  }

  dynamic "initial_lifecycle_hook" {
    for_each = var.initial_lifecycle_hook != null ? var.initial_lifecycle_hook : []
    content {
      name                    = initial_lifecycle_hook.value.name
      default_result          = initial_lifecycle_hook.value.default_result
      heartbeat_timeout       = initial_lifecycle_hook.value.heartbeat_timeout
      lifecycle_transition    = initial_lifecycle_hook.value.lifecycle_transition
      notification_metadata   = initial_lifecycle_hook.value.notification_metadata
      notification_target_arn = initial_lifecycle_hook.value.notification_target_arn
      role_arn                = initial_lifecycle_hook.value.role_arn
    }
  }

  dynamic "instance_maintenance_policy" {
    for_each = var.instance_maintenance_policy != null ? [var.instance_maintenance_policy] : []
    content {
      min_healthy_percentage = instance_maintenance_policy.value.min_healthy_percentage
      max_healthy_percentage = instance_maintenance_policy.value.max_healthy_percentage
    }
  }

  dynamic "traffic_source" {
    for_each = var.traffic_source != null ? var.traffic_source : []
    content {
      identifier = traffic_source.value.identifier
      type       = traffic_source.value.type
    }
  }

  dynamic "tag" {
    for_each = var.tag != null ? var.tag : []
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }

  dynamic "instance_refresh" {
    for_each = var.instance_refresh != null ? [var.instance_refresh] : []
    content {
      strategy = instance_refresh.value.strategy
      triggers = instance_refresh.value.triggers

      dynamic "preferences" {
        for_each = instance_refresh.value.preferences != null ? [instance_refresh.value.preferences] : []
        content {
          checkpoint_delay             = preferences.value.checkpoint_delay
          checkpoint_percentages       = preferences.value.checkpoint_percentages
          instance_warmup              = preferences.value.instance_warmup
          max_healthy_percentage       = preferences.value.max_healthy_percentage
          min_healthy_percentage       = preferences.value.min_healthy_percentage
          skip_matching                = preferences.value.skip_matching
          auto_rollback                = preferences.value.auto_rollback
          scale_in_protected_instances = preferences.value.scale_in_protected_instances
          standby_instances            = preferences.value.standby_instances

          dynamic "alarm_specification" {
            for_each = preferences.value.alarm_specification != null ? [preferences.value.alarm_specification] : []
            content {
              alarms = alarm_specification.value.alarms
            }
          }
        }
      }
    }
  }

  dynamic "warm_pool" {
    for_each = var.warm_pool != null ? [var.warm_pool] : []
    content {
      max_group_prepared_capacity = warm_pool.value.max_group_prepared_capacity
      min_size                    = warm_pool.value.min_size
      pool_state                  = warm_pool.value.pool_state

      dynamic "instance_reuse_policy" {
        for_each = warm_pool.value.instance_reuse_policy != null ? [warm_pool.value.instance_reuse_policy] : []
        content {
          reuse_on_scale_in = instance_reuse_policy.value.reuse_on_scale_in
        }
      }
    }
  }

  timeouts {
    delete = "15m"
  }
}