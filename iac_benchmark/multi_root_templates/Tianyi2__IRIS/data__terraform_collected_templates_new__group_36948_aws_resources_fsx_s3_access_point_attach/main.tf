resource "aws_fsx_s3_access_point_attachment" "this" {
  name   = var.name
  type   = var.type
  region = var.region

  openzfs_configuration {
    volume_id = var.openzfs_configuration.volume_id

    file_system_identity {
      type = var.openzfs_configuration.file_system_identity.type

      posix_user {
        uid            = var.openzfs_configuration.file_system_identity.posix_user.uid
        gid            = var.openzfs_configuration.file_system_identity.posix_user.gid
        secondary_gids = var.openzfs_configuration.file_system_identity.posix_user.secondary_gids
      }
    }
  }

  dynamic "s3_access_point" {
    for_each = var.s3_access_point != null ? [var.s3_access_point] : []
    content {
      policy = s3_access_point.value.policy

      dynamic "vpc_configuration" {
        for_each = s3_access_point.value.vpc_configuration != null ? [s3_access_point.value.vpc_configuration] : []
        content {
          vpc_id = vpc_configuration.value.vpc_id
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}