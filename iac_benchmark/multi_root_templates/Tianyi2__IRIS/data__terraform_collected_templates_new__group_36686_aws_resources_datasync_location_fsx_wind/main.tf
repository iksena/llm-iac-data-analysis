resource "aws_datasync_location_fsx_windows_file_system" "this" {
  region              = var.region
  fsx_filesystem_arn  = var.fsx_filesystem_arn
  password            = var.password
  user                = var.user
  domain              = var.domain
  security_group_arns = var.security_group_arns
  subdirectory        = var.subdirectory
  tags                = var.tags
}