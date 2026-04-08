resource "aws_iam_user" "this" {
  name                 = var.name
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
  tags                 = var.tags
}