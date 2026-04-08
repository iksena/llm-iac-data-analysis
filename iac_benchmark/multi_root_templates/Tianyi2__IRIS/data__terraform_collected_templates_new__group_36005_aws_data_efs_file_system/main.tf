data "aws_efs_file_system" "this" {
  region         = var.region
  file_system_id = var.file_system_id
  creation_token = var.creation_token
  tags           = var.tags
}