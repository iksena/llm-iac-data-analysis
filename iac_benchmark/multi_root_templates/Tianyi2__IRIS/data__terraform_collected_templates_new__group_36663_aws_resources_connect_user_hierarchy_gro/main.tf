resource "aws_connect_user_hierarchy_group" "this" {
  region          = var.region
  instance_id     = var.instance_id
  name            = var.name
  parent_group_id = var.parent_group_id
  tags            = var.tags
}