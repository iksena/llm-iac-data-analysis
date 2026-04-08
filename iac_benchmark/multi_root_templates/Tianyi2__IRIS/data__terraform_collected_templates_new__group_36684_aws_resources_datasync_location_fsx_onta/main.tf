resource "aws_datasync_location_fsx_ontap_file_system" "this" {
  security_group_arns         = var.security_group_arns
  storage_virtual_machine_arn = var.storage_virtual_machine_arn

  dynamic "protocol" {
    for_each = var.protocol != null ? [var.protocol] : []
    content {
      dynamic "nfs" {
        for_each = protocol.value.nfs != null ? [protocol.value.nfs] : []
        content {
          dynamic "mount_options" {
            for_each = nfs.value.mount_options != null ? [nfs.value.mount_options] : []
            content {
              version = mount_options.value.version
            }
          }
        }
      }

      dynamic "smb" {
        for_each = protocol.value.smb != null ? [protocol.value.smb] : []
        content {
          domain   = smb.value.domain
          password = smb.value.password
          user     = smb.value.user

          dynamic "mount_options" {
            for_each = smb.value.mount_options != null ? [smb.value.mount_options] : []
            content {
              version = mount_options.value.version
            }
          }
        }
      }
    }
  }

  region       = var.region
  subdirectory = var.subdirectory
  tags         = var.tags
}