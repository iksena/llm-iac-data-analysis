data "aws_efs_mount_target" "this" {
  region          = var.region
  access_point_id = var.access_point_id
  file_system_id  = var.file_system_id
  mount_target_id = var.mount_target_id
}