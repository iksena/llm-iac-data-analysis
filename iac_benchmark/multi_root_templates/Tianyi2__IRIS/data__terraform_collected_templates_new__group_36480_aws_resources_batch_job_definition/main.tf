resource "aws_batch_job_definition" "this" {
  name = var.name
  type = var.type

  region                     = var.region
  container_properties       = var.container_properties
  deregister_on_new_revision = var.deregister_on_new_revision
  ecs_properties             = var.ecs_properties
  node_properties            = var.node_properties
  parameters                 = var.parameters
  platform_capabilities      = var.platform_capabilities
  propagate_tags             = var.propagate_tags
  scheduling_priority        = var.scheduling_priority
  tags                       = var.tags

  dynamic "eks_properties" {
    for_each = var.eks_properties != null ? [var.eks_properties] : []
    content {
      dynamic "pod_properties" {
        for_each = eks_properties.value.pod_properties != null ? [eks_properties.value.pod_properties] : []
        content {
          dns_policy              = pod_properties.value.dns_policy
          host_network            = pod_properties.value.host_network
          service_account_name    = pod_properties.value.service_account_name
          share_process_namespace = pod_properties.value.share_process_namespace

          dynamic "containers" {
            for_each = pod_properties.value.containers != null ? pod_properties.value.containers : []
            content {
              args              = containers.value.args
              command           = containers.value.command
              image             = containers.value.image
              image_pull_policy = containers.value.image_pull_policy
              name              = containers.value.name

              dynamic "env" {
                for_each = containers.value.env != null ? containers.value.env : []
                content {
                  name  = env.value.name
                  value = env.value.value
                }
              }

              dynamic "resources" {
                for_each = containers.value.resources != null ? [containers.value.resources] : []
                content {
                  limits   = resources.value.limits
                  requests = resources.value.requests
                }
              }

              dynamic "security_context" {
                for_each = containers.value.security_context != null ? [containers.value.security_context] : []
                content {
                  privileged                 = security_context.value.privileged
                  read_only_root_file_system = security_context.value.read_only_root_filesystem
                  run_as_group               = security_context.value.run_as_group
                  run_as_non_root            = security_context.value.run_as_non_root
                  run_as_user                = security_context.value.run_as_user
                }
              }

              dynamic "volume_mounts" {
                for_each = containers.value.volume_mounts != null ? containers.value.volume_mounts : []
                content {
                  mount_path = volume_mounts.value.mount_path
                  name       = volume_mounts.value.name
                  read_only  = volume_mounts.value.read_only
                }
              }
            }
          }

          dynamic "init_containers" {
            for_each = pod_properties.value.init_containers != null ? pod_properties.value.init_containers : []
            content {
              args              = init_containers.value.args
              command           = init_containers.value.command
              image             = init_containers.value.image
              image_pull_policy = init_containers.value.image_pull_policy
              name              = init_containers.value.name

              dynamic "env" {
                for_each = init_containers.value.env != null ? init_containers.value.env : []
                content {
                  name  = env.value.name
                  value = env.value.value
                }
              }

              dynamic "resources" {
                for_each = init_containers.value.resources != null ? [init_containers.value.resources] : []
                content {
                  limits   = resources.value.limits
                  requests = resources.value.requests
                }
              }

              dynamic "security_context" {
                for_each = init_containers.value.security_context != null ? [init_containers.value.security_context] : []
                content {
                  privileged                 = security_context.value.privileged
                  read_only_root_file_system = security_context.value.read_only_root_filesystem
                  run_as_group               = security_context.value.run_as_group
                  run_as_non_root            = security_context.value.run_as_non_root
                  run_as_user                = security_context.value.run_as_user
                }
              }

              dynamic "volume_mounts" {
                for_each = init_containers.value.volume_mounts != null ? init_containers.value.volume_mounts : []
                content {
                  mount_path = volume_mounts.value.mount_path
                  name       = volume_mounts.value.name
                  read_only  = volume_mounts.value.read_only
                }
              }
            }
          }

          dynamic "image_pull_secret" {
            for_each = pod_properties.value.image_pull_secret != null ? pod_properties.value.image_pull_secret : []
            content {
              name = image_pull_secret.value.name
            }
          }

          dynamic "metadata" {
            for_each = pod_properties.value.metadata != null ? [pod_properties.value.metadata] : []
            content {
              labels = metadata.value.labels
            }
          }

          dynamic "volumes" {
            for_each = pod_properties.value.volumes != null ? pod_properties.value.volumes : []
            content {
              name = volumes.value.name

              dynamic "empty_dir" {
                for_each = volumes.value.empty_dir != null ? [volumes.value.empty_dir] : []
                content {
                  medium     = empty_dir.value.medium
                  size_limit = empty_dir.value.size_limit
                }
              }

              dynamic "host_path" {
                for_each = volumes.value.host_path != null ? [volumes.value.host_path] : []
                content {
                  path = host_path.value.path
                }
              }

              dynamic "secret" {
                for_each = volumes.value.secret != null ? [volumes.value.secret] : []
                content {
                  secret_name = secret.value.secret_name
                  optional    = secret.value.optional
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "retry_strategy" {
    for_each = var.retry_strategy != null ? [var.retry_strategy] : []
    content {
      attempts = retry_strategy.value.attempts

      dynamic "evaluate_on_exit" {
        for_each = retry_strategy.value.evaluate_on_exit != null ? retry_strategy.value.evaluate_on_exit : []
        content {
          action           = evaluate_on_exit.value.action
          on_exit_code     = evaluate_on_exit.value.on_exit_code
          on_reason        = evaluate_on_exit.value.on_reason
          on_status_reason = evaluate_on_exit.value.on_status_reason
        }
      }
    }
  }

  dynamic "timeout" {
    for_each = var.timeout != null ? [var.timeout] : []
    content {
      attempt_duration_seconds = timeout.value.attempt_duration_seconds
    }
  }
}