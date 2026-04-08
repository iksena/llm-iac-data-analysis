resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = var.role_arn

  vpc_config {
    endpoint_private_access = var.vpc_config.endpoint_private_access
    endpoint_public_access  = var.vpc_config.endpoint_public_access
    public_access_cidrs     = var.vpc_config.public_access_cidrs
    security_group_ids      = var.vpc_config.security_group_ids
    subnet_ids              = var.vpc_config.subnet_ids
  }

  dynamic "access_config" {
    for_each = var.access_config != null ? [var.access_config] : []
    content {
      authentication_mode                         = access_config.value.authentication_mode
      bootstrap_cluster_creator_admin_permissions = access_config.value.bootstrap_cluster_creator_admin_permissions
    }
  }

  bootstrap_self_managed_addons = var.bootstrap_self_managed_addons

  dynamic "compute_config" {
    for_each = var.compute_config != null ? [var.compute_config] : []
    content {
      enabled       = compute_config.value.enabled
      node_pools    = compute_config.value.node_pools
      node_role_arn = compute_config.value.node_role_arn
    }
  }

  deletion_protection       = var.deletion_protection
  enabled_cluster_log_types = var.enabled_cluster_log_types
  force_update_version      = var.force_update_version

  dynamic "encryption_config" {
    for_each = var.encryption_config != null ? var.encryption_config : []
    content {
      provider {
        key_arn = encryption_config.value.provider.key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.kubernetes_network_config != null ? [var.kubernetes_network_config] : []
    content {
      dynamic "elastic_load_balancing" {
        for_each = kubernetes_network_config.value.elastic_load_balancing != null ? [kubernetes_network_config.value.elastic_load_balancing] : []
        content {
          enabled = elastic_load_balancing.value.enabled
        }
      }
      service_ipv4_cidr = kubernetes_network_config.value.service_ipv4_cidr
      ip_family         = kubernetes_network_config.value.ip_family
    }
  }

  dynamic "outpost_config" {
    for_each = var.outpost_config != null ? [var.outpost_config] : []
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type

      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control_plane_placement != null ? [outpost_config.value.control_plane_placement] : []
        content {
          group_name = control_plane_placement.value.group_name
        }
      }

      outpost_arns = outpost_config.value.outpost_arns
    }
  }

  region = var.region

  dynamic "remote_network_config" {
    for_each = var.remote_network_config != null ? [var.remote_network_config] : []
    content {
      dynamic "remote_node_networks" {
        for_each = remote_network_config.value.remote_node_networks != null ? [remote_network_config.value.remote_node_networks] : []
        content {
          cidrs = remote_node_networks.value.cidrs
        }
      }

      dynamic "remote_pod_networks" {
        for_each = remote_network_config.value.remote_pod_networks != null ? [remote_network_config.value.remote_pod_networks] : []
        content {
          cidrs = remote_pod_networks.value.cidrs
        }
      }
    }
  }

  dynamic "storage_config" {
    for_each = var.storage_config != null ? [var.storage_config] : []
    content {
      dynamic "block_storage" {
        for_each = storage_config.value.block_storage != null ? [storage_config.value.block_storage] : []
        content {
          enabled = block_storage.value.enabled
        }
      }
    }
  }

  tags = var.tags

  dynamic "upgrade_policy" {
    for_each = var.upgrade_policy != null ? [var.upgrade_policy] : []
    content {
      support_type = upgrade_policy.value.support_type
    }
  }

  version = var.kubernetes_version

  dynamic "zonal_shift_config" {
    for_each = var.zonal_shift_config != null ? [var.zonal_shift_config] : []
    content {
      enabled = zonal_shift_config.value.enabled
    }
  }
}