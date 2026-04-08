data "aws_efs_access_point" "this" {
  region          = var.region
  access_point_id = var.access_point_id
}