data "aws_connect_user_hierarchy_structure" "this" {
  instance_id = var.instance_id
  region      = var.region
}