resource "aws_iam_user_policy" "this" {
  name        = var.name
  name_prefix = var.name_prefix
  user        = var.user
  policy      = var.policy
}