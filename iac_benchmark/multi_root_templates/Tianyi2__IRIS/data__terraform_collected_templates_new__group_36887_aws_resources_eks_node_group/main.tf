resource "aws_eks_node_group" "this" {
  cluster_name  = var.cluster_name
  node_role_arn = var.node_role_arn
  subnet_ids    = var.subnet_ids

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  region                 = var.region
  ami_type               = var.ami_type
  capacity_type          = var.capacity_type
  disk_size              = var.disk_size
  force_update_version   = var.force_update_version
  instance_types         = var.instance_types
  labels                 = var.labels
  node_group_name        = var.node_group_name
  node_group_name_prefix = var.node_group_name_prefix
  release_version        = var.release_version
  tags                   = var.tags
  version                = var.kubernetes_version

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = launch_template.value.id
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }

  dynamic "node_repair_config" {
    for_each = var.node_repair_config != null ? [var.node_repair_config] : []
    content {
      enabled = node_repair_config.value.enabled
    }
  }

  dynamic "remote_access" {
    for_each = var.remote_access != null ? [var.remote_access] : []
    content {
      ec2_ssh_key               = remote_access.value.ec2_ssh_key
      source_security_group_ids = remote_access.value.source_security_group_ids
    }
  }

  dynamic "taint" {
    for_each = var.taint != null ? var.taint : []
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  dynamic "update_config" {
    for_each = var.update_config != null ? [var.update_config] : []
    content {
      max_unavailable            = update_config.value.max_unavailable
      max_unavailable_percentage = update_config.value.max_unavailable_percentage
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}