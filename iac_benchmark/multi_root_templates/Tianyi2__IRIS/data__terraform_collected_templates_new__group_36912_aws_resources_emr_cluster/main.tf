resource "aws_emr_cluster" "this" {
  name          = var.name
  release_label = var.release_label
  service_role  = var.service_role

  region                            = var.region
  additional_info                   = var.additional_info
  applications                      = var.applications
  autoscaling_role                  = var.autoscaling_role
  custom_ami_id                     = var.custom_ami_id
  ebs_root_volume_size              = var.ebs_root_volume_size
  keep_job_flow_alive_when_no_steps = var.keep_job_flow_alive_when_no_steps
  list_steps_states                 = var.list_steps_states
  log_encryption_kms_key_id         = var.log_encryption_kms_key_id
  log_uri                           = var.log_uri
  os_release_label                  = var.os_release_label
  scale_down_behavior               = var.scale_down_behavior
  security_configuration            = var.security_configuration
  step_concurrency_level            = var.step_concurrency_level
  tags                              = var.tags
  termination_protection            = var.termination_protection
  unhealthy_node_replacement        = var.unhealthy_node_replacement
  visible_to_all_users              = var.visible_to_all_users
  configurations_json               = var.configurations_json

  dynamic "auto_termination_policy" {
    for_each = var.auto_termination_policy != null ? [var.auto_termination_policy] : []
    content {
      idle_timeout = auto_termination_policy.value.idle_timeout
    }
  }

  dynamic "bootstrap_action" {
    for_each = var.bootstrap_action
    content {
      name = bootstrap_action.value.name
      path = bootstrap_action.value.path
      args = bootstrap_action.value.args
    }
  }


  dynamic "core_instance_fleet" {
    for_each = var.core_instance_fleet != null ? [var.core_instance_fleet] : []
    content {
      name                      = core_instance_fleet.value.name
      target_on_demand_capacity = core_instance_fleet.value.target_on_demand_capacity
      target_spot_capacity      = core_instance_fleet.value.target_spot_capacity

      dynamic "instance_type_configs" {
        for_each = core_instance_fleet.value.instance_type_configs
        content {
          instance_type                              = instance_type_configs.value.instance_type
          bid_price                                  = instance_type_configs.value.bid_price
          bid_price_as_percentage_of_on_demand_price = instance_type_configs.value.bid_price_as_percentage_of_on_demand_price
          weighted_capacity                          = instance_type_configs.value.weighted_capacity

          dynamic "configurations" {
            for_each = instance_type_configs.value.configurations
            content {
              classification = configurations.value.classification
              properties     = configurations.value.properties
            }
          }

          dynamic "ebs_config" {
            for_each = instance_type_configs.value.ebs_config
            content {
              iops                 = ebs_config.value.iops
              size                 = ebs_config.value.size
              type                 = ebs_config.value.type
              volumes_per_instance = ebs_config.value.volumes_per_instance
            }
          }
        }
      }

      dynamic "launch_specifications" {
        for_each = core_instance_fleet.value.launch_specifications != null ? [core_instance_fleet.value.launch_specifications] : []
        content {
          dynamic "on_demand_specification" {
            for_each = launch_specifications.value.on_demand_specification != null ? [launch_specifications.value.on_demand_specification] : []
            content {
              allocation_strategy = on_demand_specification.value.allocation_strategy
            }
          }

          dynamic "spot_specification" {
            for_each = launch_specifications.value.spot_specification != null ? [launch_specifications.value.spot_specification] : []
            content {
              allocation_strategy      = spot_specification.value.allocation_strategy
              block_duration_minutes   = spot_specification.value.block_duration_minutes
              timeout_action           = spot_specification.value.timeout_action
              timeout_duration_minutes = spot_specification.value.timeout_duration_minutes
            }
          }
        }
      }
    }
  }

  dynamic "core_instance_group" {
    for_each = var.core_instance_group != null ? [var.core_instance_group] : []
    content {
      instance_type      = core_instance_group.value.instance_type
      autoscaling_policy = core_instance_group.value.autoscaling_policy
      bid_price          = core_instance_group.value.bid_price
      instance_count     = core_instance_group.value.instance_count
      name               = core_instance_group.value.name

      dynamic "ebs_config" {
        for_each = core_instance_group.value.ebs_config
        content {
          iops                 = ebs_config.value.iops
          size                 = ebs_config.value.size
          type                 = ebs_config.value.type
          throughput           = ebs_config.value.throughput
          volumes_per_instance = ebs_config.value.volumes_per_instance
        }
      }
    }
  }

  dynamic "ec2_attributes" {
    for_each = var.ec2_attributes != null ? [var.ec2_attributes] : []
    content {
      instance_profile                  = ec2_attributes.value.instance_profile
      additional_master_security_groups = ec2_attributes.value.additional_master_security_groups
      additional_slave_security_groups  = ec2_attributes.value.additional_slave_security_groups
      emr_managed_master_security_group = ec2_attributes.value.emr_managed_master_security_group
      emr_managed_slave_security_group  = ec2_attributes.value.emr_managed_slave_security_group
      key_name                          = ec2_attributes.value.key_name
      service_access_security_group     = ec2_attributes.value.service_access_security_group
      subnet_id                         = ec2_attributes.value.subnet_id
      subnet_ids                        = ec2_attributes.value.subnet_ids
    }
  }

  dynamic "kerberos_attributes" {
    for_each = var.kerberos_attributes != null ? [var.kerberos_attributes] : []
    content {
      kdc_admin_password                   = kerberos_attributes.value.kdc_admin_password
      realm                                = kerberos_attributes.value.realm
      ad_domain_join_password              = kerberos_attributes.value.ad_domain_join_password
      ad_domain_join_user                  = kerberos_attributes.value.ad_domain_join_user
      cross_realm_trust_principal_password = kerberos_attributes.value.cross_realm_trust_principal_password
    }
  }

  dynamic "master_instance_fleet" {
    for_each = var.master_instance_fleet != null ? [var.master_instance_fleet] : []
    content {
      name                      = master_instance_fleet.value.name
      target_on_demand_capacity = master_instance_fleet.value.target_on_demand_capacity
      target_spot_capacity      = master_instance_fleet.value.target_spot_capacity

      dynamic "instance_type_configs" {
        for_each = master_instance_fleet.value.instance_type_configs
        content {
          instance_type                              = instance_type_configs.value.instance_type
          bid_price                                  = instance_type_configs.value.bid_price
          bid_price_as_percentage_of_on_demand_price = instance_type_configs.value.bid_price_as_percentage_of_on_demand_price
          weighted_capacity                          = instance_type_configs.value.weighted_capacity

          dynamic "configurations" {
            for_each = instance_type_configs.value.configurations
            content {
              classification = configurations.value.classification
              properties     = configurations.value.properties
            }
          }

          dynamic "ebs_config" {
            for_each = instance_type_configs.value.ebs_config
            content {
              iops                 = ebs_config.value.iops
              size                 = ebs_config.value.size
              type                 = ebs_config.value.type
              volumes_per_instance = ebs_config.value.volumes_per_instance
            }
          }
        }
      }

      dynamic "launch_specifications" {
        for_each = master_instance_fleet.value.launch_specifications != null ? [master_instance_fleet.value.launch_specifications] : []
        content {
          dynamic "on_demand_specification" {
            for_each = launch_specifications.value.on_demand_specification != null ? [launch_specifications.value.on_demand_specification] : []
            content {
              allocation_strategy = on_demand_specification.value.allocation_strategy
            }
          }

          dynamic "spot_specification" {
            for_each = launch_specifications.value.spot_specification != null ? [launch_specifications.value.spot_specification] : []
            content {
              allocation_strategy      = spot_specification.value.allocation_strategy
              block_duration_minutes   = spot_specification.value.block_duration_minutes
              timeout_action           = spot_specification.value.timeout_action
              timeout_duration_minutes = spot_specification.value.timeout_duration_minutes
            }
          }
        }
      }
    }
  }

  dynamic "master_instance_group" {
    for_each = var.master_instance_group != null ? [var.master_instance_group] : []
    content {
      instance_type  = master_instance_group.value.instance_type
      bid_price      = master_instance_group.value.bid_price
      instance_count = master_instance_group.value.instance_count
      name           = master_instance_group.value.name

      dynamic "ebs_config" {
        for_each = master_instance_group.value.ebs_config
        content {
          iops                 = ebs_config.value.iops
          size                 = ebs_config.value.size
          type                 = ebs_config.value.type
          throughput           = ebs_config.value.throughput
          volumes_per_instance = ebs_config.value.volumes_per_instance
        }
      }
    }
  }

  dynamic "step" {
    for_each = var.step
    content {
      action_on_failure = step.value.action_on_failure
      name              = step.value.name

      hadoop_jar_step {
        jar        = step.value.hadoop_jar_step.jar
        args       = step.value.hadoop_jar_step.args
        main_class = step.value.hadoop_jar_step.main_class
        properties = step.value.hadoop_jar_step.properties
      }
    }
  }

  dynamic "placement_group_config" {
    for_each = var.placement_group_config
    content {
      instance_role      = placement_group_config.value.instance_role
      placement_strategy = placement_group_config.value.placement_strategy
    }
  }
}