data "aws_efs_access_points" "this" {
  region         = var.region
  file_system_id = var.file_system_id
}