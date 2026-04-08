resource "aws_workspaces_workspace" "this" {
  region                         = var.region
  directory_id                   = var.directory_id
  bundle_id                      = var.bundle_id
  user_name                      = var.user_name
  root_volume_encryption_enabled = var.root_volume_encryption_enabled
  user_volume_encryption_enabled = var.user_volume_encryption_enabled
  volume_encryption_key          = var.volume_encryption_key
  tags                           = var.tags

  dynamic "workspace_properties" {
    for_each = var.workspace_properties != null ? [var.workspace_properties] : []
    content {
      compute_type_name                         = workspace_properties.value.compute_type_name
      root_volume_size_gib                      = workspace_properties.value.root_volume_size_gib
      running_mode                              = workspace_properties.value.running_mode
      running_mode_auto_stop_timeout_in_minutes = workspace_properties.value.running_mode_auto_stop_timeout_in_minutes
      user_volume_size_gib                      = workspace_properties.value.user_volume_size_gib
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}