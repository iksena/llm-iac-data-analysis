data "aws_connect_user_hierarchy_group" "this" {
  region             = var.region
  hierarchy_group_id = var.hierarchy_group_id
  instance_id        = var.instance_id
  name               = var.name
}