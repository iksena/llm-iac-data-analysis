resource "aws_ecs_service" "this" {
  name = var.name

  region                             = var.region
  cluster                            = var.cluster
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  enable_execute_command             = var.enable_execute_command
  force_delete                       = var.force_delete
  force_new_deployment               = var.force_new_deployment
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  iam_role                           = var.iam_role
  launch_type                        = var.launch_type
  platform_version                   = var.platform_version
  propagate_tags                     = var.propagate_tags
  scheduling_strategy                = var.scheduling_strategy
  sigint_rollback                    = var.sigint_rollback
  tags                               = var.tags
  triggers                           = var.triggers
  wait_for_steady_state              = var.wait_for_steady_state
  availability_zone_rebalancing      = var.availability_zone_rebalancing

  dynamic "alarms" {
    for_each = var.alarms != null ? [var.alarms] : []
    content {
      alarm_names = alarms.value.alarm_names
      enable      = alarms.value.enable
      rollback    = alarms.value.rollback
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      base              = capacity_provider_strategy.value.base
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = var.deployment_circuit_breaker != null ? [var.deployment_circuit_breaker] : []
    content {
      enable   = deployment_circuit_breaker.value.enable
      rollback = deployment_circuit_breaker.value.rollback
    }
  }

  dynamic "deployment_configuration" {
    for_each = var.deployment_configuration != null ? [var.deployment_configuration] : []
    content {
      strategy             = deployment_configuration.value.strategy
      bake_time_in_minutes = deployment_configuration.value.bake_time_in_minutes

      dynamic "lifecycle_hook" {
        for_each = deployment_configuration.value.lifecycle_hook != null ? [deployment_configuration.value.lifecycle_hook] : []
        content {
          hook_target_arn  = lifecycle_hook.value.hook_target_arn
          role_arn         = lifecycle_hook.value.role_arn
          lifecycle_stages = lifecycle_hook.value.lifecycle_stages
        }
      }
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller != null ? [var.deployment_controller] : []
    content {
      type = deployment_controller.value.type
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer
    content {
      elb_name         = load_balancer.value.elb_name
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port

      dynamic "advanced_configuration" {
        for_each = load_balancer.value.advanced_configuration != null ? [load_balancer.value.advanced_configuration] : []
        content {
          alternate_target_group_arn = advanced_configuration.value.alternate_target_group_arn
          production_listener_rule   = advanced_configuration.value.production_listener_rule
          role_arn                   = advanced_configuration.value.role_arn
          test_listener_rule         = advanced_configuration.value.test_listener_rule
        }
      }
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration != null ? [var.network_configuration] : []
    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registries != null ? [var.service_registries] : []
    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
      container_name = service_registries.value.container_name
    }
  }

  dynamic "service_connect_configuration" {
    for_each = var.service_connect_configuration != null ? [var.service_connect_configuration] : []
    content {
      enabled   = service_connect_configuration.value.enabled
      namespace = service_connect_configuration.value.namespace

      dynamic "log_configuration" {
        for_each = service_connect_configuration.value.log_configuration != null ? [service_connect_configuration.value.log_configuration] : []
        content {
          log_driver = log_configuration.value.log_driver
          options    = log_configuration.value.options

          dynamic "secret_option" {
            for_each = log_configuration.value.secret_option != null ? log_configuration.value.secret_option : []
            content {
              name       = secret_option.value.name
              value_from = secret_option.value.value_from
            }
          }
        }
      }

      dynamic "service" {
        for_each = service_connect_configuration.value.service != null ? service_connect_configuration.value.service : []
        content {
          discovery_name        = service.value.discovery_name
          ingress_port_override = service.value.ingress_port_override
          port_name             = service.value.port_name

          dynamic "client_alias" {
            for_each = service.value.client_alias != null ? service.value.client_alias : []
            content {
              dns_name = client_alias.value.dns_name
              port     = client_alias.value.port

              dynamic "test_traffic_rules" {
                for_each = client_alias.value.test_traffic_rules != null ? [client_alias.value.test_traffic_rules] : []
                content {
                  dynamic "header" {
                    for_each = test_traffic_rules.value.header != null ? test_traffic_rules.value.header : []
                    content {
                      name = header.value.name

                      dynamic "value" {
                        for_each = header.value.value != null ? [header.value.value] : []
                        content {
                          exact = value.value.exact
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "timeout" {
            for_each = service.value.timeout != null ? [service.value.timeout] : []
            content {
              idle_timeout_seconds        = timeout.value.idle_timeout_seconds
              per_request_timeout_seconds = timeout.value.per_request_timeout_seconds
            }
          }

          dynamic "tls" {
            for_each = service.value.tls != null ? [service.value.tls] : []
            content {
              kms_key  = tls.value.kms_key
              role_arn = tls.value.role_arn

              dynamic "issuer_cert_authority" {
                for_each = tls.value.issuer_cert_authority != null ? [tls.value.issuer_cert_authority] : []
                content {
                  aws_pca_authority_arn = issuer_cert_authority.value.aws_pca_authority_arn
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "volume_configuration" {
    for_each = var.volume_configuration
    content {
      name = volume_configuration.value.name

      dynamic "managed_ebs_volume" {
        for_each = volume_configuration.value.managed_ebs_volume != null ? [volume_configuration.value.managed_ebs_volume] : []
        content {
          role_arn                   = managed_ebs_volume.value.role_arn
          encrypted                  = managed_ebs_volume.value.encrypted
          file_system_type           = managed_ebs_volume.value.file_system_type
          iops                       = managed_ebs_volume.value.iops
          kms_key_id                 = managed_ebs_volume.value.kms_key_id
          size_in_gb                 = managed_ebs_volume.value.size_in_gb
          snapshot_id                = managed_ebs_volume.value.snapshot_id
          throughput                 = managed_ebs_volume.value.throughput
          volume_initialization_rate = managed_ebs_volume.value.volume_initialization_rate
          volume_type                = managed_ebs_volume.value.volume_type

          dynamic "tag_specifications" {
            for_each = managed_ebs_volume.value.tag_specifications != null ? managed_ebs_volume.value.tag_specifications : []
            content {
              resource_type  = tag_specifications.value.resource_type
              propagate_tags = tag_specifications.value.propagate_tags
              tags           = tag_specifications.value.tags
            }
          }
        }
      }
    }
  }

  dynamic "vpc_lattice_configurations" {
    for_each = var.vpc_lattice_configurations
    content {
      role_arn         = vpc_lattice_configurations.value.role_arn
      target_group_arn = vpc_lattice_configurations.value.target_group_arn
      port_name        = vpc_lattice_configurations.value.port_name
    }
  }
}