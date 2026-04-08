data "aws_fsx_ontap_file_system" "this" {
  region = var.region
  id     = var.id
}