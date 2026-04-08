resource "aws_iam_group_policy" "this" {
  policy      = var.policy
  name        = var.name
  name_prefix = var.name_prefix
  group       = var.group
}