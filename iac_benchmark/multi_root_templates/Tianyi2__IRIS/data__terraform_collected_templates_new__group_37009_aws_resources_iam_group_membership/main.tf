resource "aws_iam_group_membership" "this" {
  name  = var.name
  users = var.users
  group = var.group
}