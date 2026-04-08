resource "aws_datasync_location_efs" "this" {
  region                      = var.region
  access_point_arn            = var.access_point_arn
  efs_file_system_arn         = var.efs_file_system_arn
  file_system_access_role_arn = var.file_system_access_role_arn
  in_transit_encryption       = var.in_transit_encryption
  subdirectory                = var.subdirectory
  tags                        = var.tags

  ec2_config {
    security_group_arns = var.ec2_config.security_group_arns
    subnet_arn          = var.ec2_config.subnet_arn
  }
}