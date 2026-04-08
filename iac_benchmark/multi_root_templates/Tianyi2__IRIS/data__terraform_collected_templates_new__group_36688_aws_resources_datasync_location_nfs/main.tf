resource "aws_datasync_location_nfs" "this" {
  region          = var.region
  server_hostname = var.server_hostname
  subdirectory    = var.subdirectory
  tags            = var.tags

  dynamic "mount_options" {
    for_each = var.mount_options != null ? [var.mount_options] : []
    content {
      version = mount_options.value.version
    }
  }

  on_prem_config {
    agent_arns = var.on_prem_config.agent_arns
  }
}