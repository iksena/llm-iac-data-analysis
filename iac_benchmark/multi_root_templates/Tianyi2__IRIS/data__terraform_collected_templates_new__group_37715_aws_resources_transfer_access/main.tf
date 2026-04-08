resource "aws_transfer_access" "this" {
  region              = var.region
  external_id         = var.external_id
  server_id           = var.server_id
  home_directory      = var.home_directory
  home_directory_type = var.home_directory_type
  policy              = var.policy
  role                = var.role

  dynamic "home_directory_mappings" {
    for_each = var.home_directory_mappings != null ? var.home_directory_mappings : []
    content {
      entry  = home_directory_mappings.value.entry
      target = home_directory_mappings.value.target
    }
  }

  dynamic "posix_profile" {
    for_each = var.posix_profile != null ? [var.posix_profile] : []
    content {
      gid            = posix_profile.value.gid
      uid            = posix_profile.value.uid
      secondary_gids = posix_profile.value.secondary_gids
    }
  }
}