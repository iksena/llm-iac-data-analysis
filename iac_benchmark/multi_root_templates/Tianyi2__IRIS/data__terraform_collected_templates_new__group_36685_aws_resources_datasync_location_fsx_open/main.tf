resource "aws_datasync_location_fsx_openzfs_file_system" "this" {
  region              = var.region
  fsx_filesystem_arn  = var.fsx_filesystem_arn
  security_group_arns = var.security_group_arns
  subdirectory        = var.subdirectory
  tags                = var.tags

  protocol {
    nfs {
      mount_options {
        version = var.protocol_nfs_mount_options_version
      }
    }
  }
}