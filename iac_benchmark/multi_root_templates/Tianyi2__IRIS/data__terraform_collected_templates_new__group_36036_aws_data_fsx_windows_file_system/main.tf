data "aws_fsx_windows_file_system" "this" {
  region = var.region
  id     = var.id
}